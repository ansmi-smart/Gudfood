pageextension 50059 GenJrnlPageExt extends "General Journal"
{
    layout
    {
        addafter(Description)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = all;
            }
            field("Reimbursable ANSMI"; Rec."Reimbursable ANSMI")
            {
                ApplicationArea = All;
            }
            field("Receipt ANSMI"; Rec."Receipt ANSMI")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Reconcile")
        {
            action("Excel Import ANSMI")
            {
                Caption = 'Excel Import ANSMI';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ImportExcel: Report "Excel Data ANSMI";
                begin
                    ImportExcel.PerformImport(Rec);
                end;
            }
            action("Text file Import ANSMI")
            {
                Caption = 'Text file Import ANSMI';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportTxt: Codeunit "Txt Data ANSMI";
                begin
                    ImportTxt.PerformImport(Rec);
                end;
            }
            action("Upload CSV")
            {
                Caption = 'Upload CSV ANSMI';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Uploader: Codeunit "CSV Uploader ANSMI";
                begin
                    Uploader.UploadCSV(Rec);
                end;
            }
            action("Get API ANSMI")
            {
                Caption = 'Get API ANSMI';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Uploader: Codeunit "CSV Uploader ANSMI";
                begin
                    Uploader.GetDataFromAPI(Rec);
                end;

            }
        }
    }
}
