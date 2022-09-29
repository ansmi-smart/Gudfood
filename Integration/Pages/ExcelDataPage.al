page 50062 "Excel Data ANSMI"
{
    Caption = 'Excel Data ANSMI';
    PageType = NavigatePage;
    SourceTable = "Excel Data ANSMI";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Document/Transaction ID"; Rec."Document/Transaction ID")
                {
                    ApplicationArea = all;
                }
                field("GL Account"; Rec."GL Account")
                {
                    ApplicationArea = all;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("PortfolioID/AssetID"; Rec."PortfolioID/AssetID")
                {
                    ApplicationArea = all;
                }
                field("Portfolio Description"; Rec."Portfolio Description")
                {
                    ApplicationArea = all;
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = all;
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Segment ID"; Rec."Segment ID")
                {
                    ApplicationArea = all;
                }
                field("Segment Name"; Rec."Segment Name")
                {
                    ApplicationArea = all;
                }
                field("Comment to posting"; Rec."Comment to posting")
                {
                    ApplicationArea = all;
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
                    Buffer: Record "Excel Buffer" temporary;
                    Data: Record "Excel Data ANSMI";
                    InS: InStream;
                    Filename: Text;
                    Row: Integer;
                    LastRow: Integer;
                begin
                    Data.DeleteAll();
                    if UploadIntoStream('Excel', '', '', Filename, InS) then begin
                        Buffer.OpenBookStream(InS, 'Sheet1');
                        Buffer.ReadSheet();
                        Buffer.setrange("Column No.", 4);
                        Buffer.FindLast();
                        LastRow := Buffer."Row No.";
                        Buffer.Reset();

                        for row := 2 to LastRow do begin
                            Data.Init();
                            if (GetText(Buffer, 'A', row) <> '') then begin
                                Data."Document/Transaction ID" := GetText(Buffer, 'A', row);
                                Data."GL Account" := GetText(Buffer, 'B', row);
                                Data.Period := GetDate(Buffer, 'C', row);
                                Data.Amount := GetNumber(Buffer, 'D', row);
                                Data."PortfolioID/AssetID" := GetText(Buffer, 'E', row);
                                Data."Portfolio Description" := GetText(Buffer, 'F', row);
                                Data."Batch ID" := GetText(Buffer, 'G', row);
                                Data."Batch Name" := GetText(Buffer, 'H', row);
                                Data."Segment ID" := GetText(Buffer, 'I', row);
                                Data."Segment Name" := GetText(Buffer, 'J', row);
                                Data."Comment to posting" := GetText(Buffer, 'K', row);
                                Data.Insert();
                            end;
                        end;
                    end;
                end;
            }
            action(Insert)
            {
                Caption = 'Insert to Gen. Jrnl.';
                InFooterBar = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    GenJournal: Record "Gen. Journal Line";
                    Data: Record "Excel Data ANSMI";
                    ImportNtfc: Label 'Import Completed!';
                    DimensionCode: Code[20];
                begin
                    GenJournal.Init();
                    if Data.FindSet() then
                        repeat
                            DimensionCode := getZeros(4, StrLen(Data."PortfolioID/AssetID")) + Data."PortfolioID/AssetID" + '.';
                            DimensionCode += getZeros(3, StrLen(Data."Batch ID")) + Data."Batch ID" + '.';
                            DimensionCode += getZeros(2, StrLen(Data."Segment ID")) + Data."Segment ID";
                            GenJournal."Journal Template Name" := 'GENERAL';
                            GenJournal."Journal Batch Name" := 'DEFAULT';
                            GenJournal."Line No." := 10000 * GenJournal.Count;
                            GenJournal."Posting Date" := Data.Period;
                            GenJournal."External Document No." := Data."Document/Transaction ID";
                            GenJournal."Account No." := Data."GL Account";
                            GenJournal."Amount (LCY)" := Data.Amount;
                            GenJournal."Cust. Post. Description ANSMI" := Data."Comment to posting";
                            GenJournal."Shortcut Dimension 1 Code" := DimensionCode;
                            GenJournal.Insert();
                        until (Data.Next() = 0);
                    Message(ImportNtfc);
                    CurrPage.Close();
                end;
            }
        }
    }

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