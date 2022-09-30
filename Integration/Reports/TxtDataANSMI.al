report 50060 "Txt Data ANSMI"
{
    Caption = 'Txt Data ANSMI';
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


    var
        Line: text;

    local procedure FindValue(): Text
    var
        NumberOfBytesRead: Integer;
        StartPos, EndPos : Integer;
        Result: Text;
        i: Integer;
    begin
        StartPos := Line.IndexOf('"');
        line[StartPos] := ' ';
        EndPos := Line.IndexOf('"');
        line[EndPos] := ' ';
        Result := Line.Substring(StartPos, EndPos - StartPos);
        Line := Line.Replace(Line.Substring(StartPos, EndPos - StartPos), ' ');
        exit(Result.Trim());
    end;

    local procedure PerformImport()
    var
        FileName: Text;
        FileStream: InStream;
        GenJournal: Record "Gen. Journal Line";
        ImportNtfc: Label 'Import Completed!';
        PostinDate: Date;
        TempDate: Text;
        TempDecimal: Decimal;
        VoTp, DbAcCl, DbAcNo, DbTxCd, CrAcCl, CrAcNo, CrTxCd, ExRt, InvoNo, DueDt, CID : Text;
        GenJnlAcc: Enum "Gen. Journal Account Type";
    begin
        GenJournal.Init();
        if (File.UploadIntoStream('Select .txt file for import', '', '', FileName, FileStream)) then begin
            while not FileStream.EOS do begin
                FileStream.ReadText(Line);
                if StrLen(Line) <> 0 then begin
                    if (Line.StartsWith('"')) and (line[2] in ['0' .. '9']) then begin

                        GenJournal."Journal Template Name" := 'GENERAL';
                        GenJournal."Journal Batch Name" := 'DEFAULT';
                        GenJournal."Line No." := 10000 * GenJournal.Count;

                        GenJournal."Document No." := Format(FindValue());
                        TempDate := FindValue();
                        TempDate := COPYSTR(TempDate, 1, 4) + '-' + COPYSTR(TempDate, 5, 2) + '-' + COPYSTR(TempDate, 7, 2);
                        Evaluate(PostinDate, TempDate);
                        GenJournal."Posting Date" := PostinDate;
                        VoTp := FindValue();
                        GenJournal.Description := FindValue();
                        DbAcCl := FindValue();
                        DbAcNo := FindValue();
                        DbTxCd := FindValue();
                        CrAcCl := FindValue();
                        CrAcNo := FindValue();
                        CrTxCd := FindValue();
                        GenJournal."Currency Code" := Format(FindValue());
                        ExRt := FindValue();
                        Evaluate(TempDecimal, FindValue());
                        GenJournal.Amount := TempDecimal;
                        Evaluate(TempDecimal, FindValue());

                        if (DbAcCl = '0')
                        then
                            GenJournal."Amount (LCY)" := (-1) * TempDecimal
                        else
                            GenJournal."Amount (LCY)" := TempDecimal;

                        InvoNo := FindValue();
                        DueDt := FindValue();
                        CID := FindValue();

                        if DbAcCl = '0' then begin
                            if CrAcCl = '1' then begin
                                GenJournal."Account Type" := GenJnlAcc::Customer;
                                GenJournal."Account No." := Format(CrAcNo);
                            end else
                                if CrAcCl = '2' then begin
                                    GenJournal."Account Type" := GenJnlAcc::Vendor;
                                    GenJournal."Account No." := Format(CrAcNo);
                                end else
                                    if CrAcCl = '3' then begin
                                        GenJournal."Account Type" := GenJnlAcc::"G/L Account";
                                        GenJournal."Account No." := Format(CrAcNo);
                                    end
                        end else
                            if DbAcCl = '1' then begin
                                GenJournal."Account Type" := GenJnlAcc::Customer;
                                GenJournal."Account No." := Format(DbAcNo);
                            end else
                                if DbAcCl = '2' then begin
                                    GenJournal."Account Type" := GenJnlAcc::Vendor;
                                    GenJournal."Account No." := Format(DbAcNo);
                                end else
                                    if DbAcCl = '3' then begin
                                        GenJournal."Account Type" := GenJnlAcc::"G/L Account";
                                        GenJournal."Account No." := Format(DbAcNo);
                                    end;
                        GenJournal."External Document No." := FindValue();
                        GenJournal.Insert();
                    end;
                end;
            end;
            Message(ImportNtfc);
        end;
    end;
}