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
                var
                    FileName: Text;
                    Data: Record TxtDataTable;
                    FileStream: InStream;
                    Line: Text;
                    NumberOfBytesRead: Integer;
                begin
                    rec.DeleteAll();
                    if (File.UploadIntoStream('Txt Stream', '', '', FileName, FileStream)) then begin
                        while not FileStream.EOS do begin
                            NumberOfBytesRead := FileStream.ReadText(Line);
                            Message('%1\Size: %2', Line, NumberOfBytesRead);

                        end;
                    end;
                end;
            }
            action(Insert)
            {
                Caption = 'Insert to Gen. Jrnl.';
                InFooterBar = true;
                ApplicationArea = all;

            }
        }
    }
}
