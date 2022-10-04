report 50061 "Excel Data ANSMI"
{
    Caption = 'Excel Data ANSMI';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(ExcelBuffer; "Excel Buffer")
        { }
    }
    var
        ErrorList: List of [ErrorInfo];
        ShowErrors: Codeunit "Error Messages";
        AccountError: Label 'The field Account No. of table Gen. Journal Line cannot be found in the related table (G/L Account).';
        DescriptionError: Label 'The length of the description must be less than or equal to 100 characters. Yours is bigger.';
        DimensionError: Label 'There is no such value in Dimension Values.';
        AmountError: Label 'The field Amount of table Gen. Journal Line cannot be 0 or empty.';

    procedure PerformImport(Rec: Record "Gen. Journal Line")
    var
        Buffer: Record "Excel Buffer" temporary;
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        DimensionCode: Code[20];
        GenJournal: Record "Gen. Journal Line";
        ImportNtfc: Label 'Import Completed!';
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        if UploadIntoStream('Choose .xls file for import', '', '', Filename, InS) then begin
            Buffer.OpenBookStream(InS, 'Sheet1');
            Buffer.ReadSheet();
            Buffer.setrange("Column No.", 4);
            Buffer.FindLast();
            LastRow := Buffer."Row No.";
            Buffer.Reset();
            RecRef.Open(Database::"Gen. Journal Line");
            RecRef.Init();
            GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");

            for row := 2 to LastRow do begin
                if (GetText(Buffer, 'A', row) <> '') then begin
                    DimensionCode := getZeros(4, StrLen(GetText(Buffer, 'E', row))) + GetText(Buffer, 'E', row) + '.';
                    DimensionCode += getZeros(3, StrLen(GetText(Buffer, 'G', row))) + GetText(Buffer, 'G', row) + '.';
                    DimensionCode += getZeros(2, StrLen(GetText(Buffer, 'I', row))) + GetText(Buffer, 'I', row);

                    GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                    GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournal.Validate("Line No.", 10000 * (GenJournal.Count + 1));

                    GenJournal.Validate("Posting Date", GetDate(Buffer, 'C', row));
                    GenJournal.Validate("External Document No.", GetText(Buffer, 'A', row));

                    FldRef := RecRef.Field(Rec.FieldNo("Account No."));
                    if TryValidation(FldRef, GetText(Buffer, 'B', row)) then
                        GenJournal.Validate("Account No.", GetText(Buffer, 'B', row))
                    else
                        ErrorList.Add(ErrorInfo.Create(AccountError, true, GenJournal, GenJournal.FieldNo("Account No.")));

                    FldRef := RecRef.Field(Rec.FieldNo("Amount (LCY)"));
                    if TryValidation(FldRef, GetText(Buffer, 'D', row)) then
                        GenJournal.Validate("Amount (LCY)", GetNumber(Buffer, 'D', row))
                    else
                        ErrorList.Add(ErrorInfo.Create(AmountError, true, GenJournal, GenJournal.FieldNo("Amount (LCY)")));


                    FldRef := RecRef.Field(Rec.FieldNo("Description"));
                    if TryValidation(FldRef, GetText(Buffer, 'K', row)) then
                        GenJournal.Validate("Description", GetText(Buffer, 'K', row))
                    else
                        ErrorList.Add(ErrorInfo.Create(DescriptionError, true, GenJournal, GenJournal.FieldNo("Description")));

                    FldRef := RecRef.Field(Rec.FieldNo("Shortcut Dimension 1 Code"));
                    if TryValidation(FldRef, DimensionCode) then
                        GenJournal.Validate("Shortcut Dimension 1 Code", DimensionCode)
                    else
                        ErrorList.Add(ErrorInfo.Create(DimensionError, true, GenJournal, GenJournal.FieldNo("Shortcut Dimension 1 Code")));

                    GenJournal.Insert();
                end;
            end;
            ShowErrors.ShowErrors(ErrorList, GenJournal);
        end;
    end;

    [TryFunction]
    procedure TryValidation(fldRef: FieldRef; NewValue: Variant)
    begin
        fldRef.Validate(NewValue);
    end;

    procedure GetText(var Buffer: Record "Excel Buffer" temporary; Col: Text; Row: Integer): Text
    begin
        if Buffer.Get(Row, GetColumnNumber(col)) then
            exit(Buffer."Cell Value as Text");
    end;

    procedure GetDate(var Buffer: Record "Excel Buffer" temporary; Col: Text; Row: Integer): Date
    var
        d: Date;
    begin
        if Buffer.Get(Row, GetColumnNumber(col)) then begin
            Evaluate(D, Buffer."Cell Value as Text");
            exit(D);
        end;
    end;

    procedure GetNumber(var Buffer: Record "Excel Buffer" temporary; Col: Text; Row: Integer): Decimal
    var
        d: Decimal;
    begin
        if Buffer.Get(Row, GetColumnNumber(col)) then begin
            Evaluate(d, Buffer."Cell Value as Text");
            exit(d);
        end;

    end;

    procedure GetColumnNumber(ColumnName: Text): Integer
    var
        columnIndex: Integer;
        factor: Integer;
        pos: Integer;
    begin
        factor := 1;
        for pos := strlen(ColumnName) downto 1 do
            if ColumnName[pos] >= 65 then begin
                columnIndex += factor * ((ColumnName[pos] - 65) + 1);
                factor *= 100;
            end;

        exit(columnIndex);
    end;

    local procedure getZeros(Amount: Integer; Existed: integer): Text
    var
        Zeros: Text[4];
    begin
        case Amount - Existed of
            0:
                Zeros := '';
            1:
                Zeros := '0';
            2:
                Zeros := '00';
            3:
                Zeros := '000';
        end;
        exit(Zeros);
    end;
}
