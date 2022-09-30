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

    trigger OnPreReport()
    begin
        PerformImport();
    end;


    local procedure PerformImport()
    var
        Buffer: Record "Excel Buffer" temporary;
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        DimensionCode: Code[20];
        GenJournal: Record "Gen. Journal Line";
        ImportNtfc: Label 'Import Completed!';
    begin
        if UploadIntoStream('Choose .xls file for import', '', '', Filename, InS) then begin
            Buffer.OpenBookStream(InS, 'Sheet1');
            Buffer.ReadSheet();
            Buffer.setrange("Column No.", 4);
            Buffer.FindLast();
            LastRow := Buffer."Row No.";
            Buffer.Reset();

            for row := 2 to LastRow do begin
                if (GetText(Buffer, 'A', row) <> '') then begin
                    DimensionCode := getZeros(4, StrLen(GetText(Buffer, 'E', row))) + GetText(Buffer, 'E', row) + '.';
                    DimensionCode += getZeros(3, StrLen(GetText(Buffer, 'G', row))) + GetText(Buffer, 'G', row) + '.';
                    DimensionCode += getZeros(2, StrLen(GetText(Buffer, 'I', row))) + GetText(Buffer, 'I', row);

                    GenJournal."Journal Template Name" := 'GENERAL';
                    GenJournal."Journal Batch Name" := 'DEFAULT';
                    GenJournal."Line No." := 10000 * GenJournal.Count;

                    GenJournal."Posting Date" := GetDate(Buffer, 'C', row);
                    GenJournal."External Document No." := GetText(Buffer, 'A', row);
                    GenJournal."Account No." := GetText(Buffer, 'B', row);
                    GenJournal."Amount (LCY)" := GetNumber(Buffer, 'D', row);
                    GenJournal."Cust. Post. Description ANSMI" := GetText(Buffer, 'K', row);
                    GenJournal."Shortcut Dimension 1 Code" := DimensionCode;
                    GenJournal.Insert();
                end;
            end;
        end;
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
