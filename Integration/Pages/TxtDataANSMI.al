page 50064 "Txt Data ANSMI"
{
    Caption = 'Txt Data ANSMI';
    PageType = NavigatePage;
    SourceTable = TxtDataTable;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field(VoNo; Rec.VoNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VoNo field.';
                }
                field(VoDt; Rec.VoDt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VoDt field.';
                }
                field(VoTp; Rec.VoTp)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VoTp field.';
                }
                field(Txt; Rec.Txt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Txt field.';
                }
                field(DbAcCl; Rec.DbAcCl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DbAcCl field.';
                }
                field(DbAcNo; Rec.DbAcNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DbAcNo field.';
                }
                field(DbTxCd; Rec.DbTxCd)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DbTxCd field.';
                }
                field(CrAcCl; Rec.CrAcCl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CrAcCl field.';
                }
                field(CrAcNo; Rec.CrAcNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CrAcNo field.';
                }
                field(CrTxCd; Rec.CrTxCd)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CrTxCd field.';
                }
                field(Cur; Rec.Cur)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cur field.';
                }
                field(ExRt; Rec.ExRt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ExRt field.';
                }
                field(CurAm; Rec.CurAm)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CurAm field.';
                }
                field(AM; Rec.AM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AM field.';
                }
                field(InvoNo; Rec.InvoNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the InvoNo field.';
                }
                field(DueDt; Rec.DueDt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DueDt field.';
                }
                field(CID; Rec.CID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CID field.';
                }
                field(AgRef; Rec.AgRef)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AgRef field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = 'Import';
                InFooterBar = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    PerformImport();
                end;
            }
            action(Insert)
            {
                Caption = 'Insert to Gen. Jrnl.';
                InFooterBar = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    PerformInsertToGenJnl();
                end;

            }
        }
    }

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
        Data: Record TxtDataTable;
        FileStream: InStream;
    begin
        Data.FindSet();
        Data.DeleteAll();
        if (File.UploadIntoStream('Select .txt file for import', '', '', FileName, FileStream)) then begin
            while not FileStream.EOS do begin
                FileStream.ReadText(Line);
                if StrLen(Line) <> 0 then begin
                    if (Line.StartsWith('"')) and (line[2] in ['0' .. '9']) then begin
                        Data.Init();
                        Data.VoNo := FindValue();
                        Data.VoDt := FindValue();
                        Data.VoDt := COPYSTR(Data.VoDt, 1, 4) + '-' + COPYSTR(Data.VoDt, 5, 2) + '-' + COPYSTR(Data.VoDt, 7, 2);
                        Data.VoTp := FindValue();
                        Data.Txt := FindValue();
                        Data.DbAcCl := FindValue();
                        Data.DbAcNo := FindValue();
                        Data.DbTxCd := FindValue();
                        Data.CrAcCl := FindValue();
                        Data.CrAcNo := FindValue();
                        Data.CrTxCd := FindValue();
                        Data.Cur := FindValue();
                        Data.ExRt := FindValue();
                        Data.CurAm := FindValue();
                        Data.AM := FindValue();
                        Data.InvoNo := FindValue();
                        Data.DueDt := FindValue();
                        Data.CID := FindValue();
                        Data.AgRef := FindValue();
                        Data.Insert();
                    end;
                end;
            end;
        end;
    end;

    local procedure PerformInsertToGenJnl()
    var
        GenJournal: Record "Gen. Journal Line";
        Data: Record TxtDataTable;
        ImportNtfc: Label 'Import Completed!';
        PostinDate: Date;
        TempDecimal: Decimal;
        GenJnlAcc: Enum "Gen. Journal Account Type";
    begin
        GenJournal.Init();
        if data.FindSet() then
            repeat
                GenJournal."Journal Template Name" := 'GENERAL';
                GenJournal."Journal Batch Name" := 'DEFAULT';
                GenJournal."Line No." := 10000 * GenJournal.Count;

                GenJournal."Document No." := Format(Data.VoNo);
                Evaluate(PostinDate, Data.VoDt);
                GenJournal."Posting Date" := PostinDate;
                GenJournal.Description := Data.Txt;
                if Data.DbAcCl = '0' then begin
                    if Data.CrAcCl = '1' then begin
                        GenJournal."Account Type" := GenJnlAcc::Customer;
                        GenJournal."Account No." := Format(Data.CrAcNo);
                    end else
                        if Data.CrAcCl = '2' then begin
                            GenJournal."Account Type" := GenJnlAcc::Vendor;
                            GenJournal."Account No." := Format(Data.CrAcNo);
                        end else
                            if Data.CrAcCl = '3' then begin
                                GenJournal."Account Type" := GenJnlAcc::"G/L Account";
                                GenJournal."Account No." := Format(Data.CrAcNo);
                            end
                end else
                    if Data.DbAcCl = '1' then begin
                        GenJournal."Account Type" := GenJnlAcc::Customer;
                        GenJournal."Account No." := Format(Data.DbAcNo);
                    end else
                        if Data.DbAcCl = '2' then begin
                            GenJournal."Account Type" := GenJnlAcc::Vendor;
                            GenJournal."Account No." := Format(Data.DbAcNo);
                        end else
                            if Data.DbAcCl = '3' then begin
                                GenJournal."Account Type" := GenJnlAcc::"G/L Account";
                                GenJournal."Account No." := Format(Data.DbAcNo);
                            end;
                GenJournal."Currency Code" := Format(Data.Cur);
                Evaluate(TempDecimal, Data.CurAm);
                GenJournal.Amount := TempDecimal;
                Evaluate(TempDecimal, Data.AM);

                if (Data.DbAcCl = '0')
                then
                    GenJournal."Amount (LCY)" := (-1) * TempDecimal
                else
                    GenJournal."Amount (LCY)" := TempDecimal;
                GenJournal."External Document No." := Data.AgRef;
                GenJournal.Insert();
            until (Data.Next() = 0);
        Message(ImportNtfc);
        CurrPage.Close();
    end;
}
