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
        }
    }
}
