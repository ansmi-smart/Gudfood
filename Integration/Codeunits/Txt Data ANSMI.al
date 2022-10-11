codeunit 50060 "Txt Data ANSMI"
{
    var
        Line: text;

    local procedure FindValue(): Text
    var
        StartPos, EndPos : Integer;
        Result: Text;
    begin
        StartPos := Line.IndexOf('"');
        line[StartPos] := ' ';
        EndPos := Line.IndexOf('"');
        line[EndPos] := ' ';
        Result := Line.Substring(StartPos, EndPos - StartPos);
        Line := Line.Replace(Line.Substring(StartPos, EndPos - StartPos), ' ');
        exit(Result.Trim());
    end;

    procedure PerformImport(Rec: Record "Gen. Journal Line")
    var
        FileName: Text;
        FileStream: InStream;
        GenJournal: Record "Gen. Journal Line";
        ImportNtfc: Label 'Import Completed!';
        PostinDate: Date;
        TempDate: Text;
        TempDecimal: Decimal;
        Description, VoTp, DbAcCl, DbAcNo, DbTxCd, CrAcCl, CrAcNo, CrTxCd, ExRt, InvoNo, DueDt, CID, Cur : Text;
        GenJnlAcc: Enum "Gen. Journal Account Type";
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        GenJournal.Init();
        RecRef.Open(Database::"Gen. Journal Line");
        RecRef.Init();
        GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if (File.UploadIntoStream('Select .txt file for import', '', '', FileName, FileStream)) then begin
            while not FileStream.EOS do begin
                FileStream.ReadText(Line);
                if StrLen(Line) <> 0 then begin
                    if (Line.StartsWith('"')) and (line[2] in ['0' .. '9']) then begin
                        GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                        GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
                        GenJournal.Validate("Line No.", 10000 * GenJournal.Count);

                        GenJournal.Validate("Document No.", Format(FindValue()));
                        TempDate := FindValue();
                        TempDate := COPYSTR(TempDate, 1, 4) + '-' + COPYSTR(TempDate, 5, 2) + '-' + COPYSTR(TempDate, 7, 2);
                        Evaluate(PostinDate, TempDate);
                        GenJournal.Validate("Posting Date", PostinDate);
                        VoTp := FindValue();
                        Description := FindValue();
                        FldRef := RecRef.Field(Rec.FieldNo(Description));
                        if TryValidation(FldRef, Description) then
                            GenJournal.Validate(Description, Description)
                        else
                            Error(ErrorInfo.Create(Description, true, Rec, Rec.FieldNo(Description)));
                        DbAcCl := FindValue();
                        DbAcNo := FindValue();
                        DbTxCd := FindValue();
                        CrAcCl := FindValue();
                        CrAcNo := FindValue();
                        CrTxCd := FindValue();
                        Cur := Format(FindValue());

                        FldRef := RecRef.Field(Rec.FieldNo("Currency Code"));
                        if TryValidation(FldRef, Cur) then
                            GenJournal.Validate("Currency Code", Cur)
                        else
                            ErrorList.Add(ErrorInfo.Create(CurrencyError, true, GenJournal, GenJournal.FieldNo("Currency Code")));

                        ExRt := FindValue();
                        Evaluate(TempDecimal, FindValue());

                        FldRef := RecRef.Field(Rec.FieldNo(Amount));
                        if TryValidation(FldRef, TempDecimal) then
                            GenJournal.Validate(Amount, TempDecimal)
                        else
                            ErrorList.Add(ErrorInfo.Create(AmountError, true, GenJournal, GenJournal.FieldNo(Amount)));

                        Evaluate(TempDecimal, FindValue());
                        FldRef := RecRef.Field(Rec.FieldNo("Amount (LCY)"));
                        if TryValidation(FldRef, TempDecimal) then begin
                            if (DbAcCl = '0') then begin
                                GenJournal.Validate("Amount (LCY)", (-1) * TempDecimal);
                            end else
                                GenJournal.Validate("Amount (LCY)", TempDecimal);
                        end else
                            ErrorList.Add(ErrorInfo.Create(AmountError, true, GenJournal, GenJournal.FieldNo("Amount (LCY)")));

                        InvoNo := FindValue();
                        DueDt := FindValue();
                        CID := FindValue();
                        FldRef := RecRef.Field(Rec.FieldNo("Account No."));
                        if DbAcCl = '0' then begin
                            if TryValidation(FldRef, Format(CrAcNo)) then begin
                                if CrAcCl = '1' then begin
                                    GenJournal.Validate("Account Type", GenJnlAcc::Customer);
                                    GenJournal.Validate("Account No.", Format(CrAcNo));
                                end else
                                    if CrAcCl = '2' then begin
                                        GenJournal.Validate("Account Type", GenJnlAcc::Vendor);
                                        GenJournal.Validate("Account No.", Format(CrAcNo));
                                    end else
                                        if CrAcCl = '3' then begin
                                            GenJournal.Validate("Account Type", GenJnlAcc::"G/L Account");
                                            GenJournal.Validate("Account No.", Format(CrAcNo));
                                        end
                            end else begin
                                if TryValidation(FldRef, Format(DbAcNo)) then begin
                                    if DbAcCl = '1' then begin
                                        GenJournal.Validate("Account Type", GenJnlAcc::Customer);
                                        GenJournal.Validate("Account No.", Format(DbAcNo));
                                    end else
                                        if DbAcCl = '2' then begin
                                            GenJournal.Validate("Account Type", GenJnlAcc::Vendor);
                                            GenJournal.Validate("Account No.", Format(DbAcNo));
                                        end else
                                            if DbAcCl = '3' then begin
                                                GenJournal.Validate("Account Type", GenJnlAcc::"G/L Account");
                                                GenJournal.Validate("Account No.", Format(DbAcNo));
                                            end;
                                end else
                                    ErrorList.Add(ErrorInfo.Create(AccountError, true, GenJournal, GenJournal.FieldNo("Account No.")));
                            end;
                            GenJournal.Validate("External Document No.", FindValue());
                            GenJournal.Insert();
                        end;
                    end;
                end;
            end;
            ShowErrors.ShowErrors(ErrorList, GenJournal);
            Message(ImportNtfc);
        end;
    end;

    [TryFunction]
    procedure TryValidation(fldRef: FieldRef; NewValue: Variant)
    begin
        fldRef.Validate(NewValue);
    end;

    var
        ErrorList: List of [ErrorInfo];
        ShowErrors: Codeunit "Error Messages";
        AccountError: Label 'The field Account No. of table Gen. Journal Line cannot be found in the related table (G/L Account).';
        CurrencyError: Label 'The field Currency Code of table Gen. Journal Line cannot be found in the related table (Currency)';
        AmountError: Label 'The field Amount of table Gen. Journal Line cannot be 0 or empty.';
        DescriptionError: Label 'The length of the description must be less than or equal to 100 characters. Yours is bigger.';
}
