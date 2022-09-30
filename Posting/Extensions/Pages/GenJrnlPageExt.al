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
                RunObject = report "Excel Data ANSMI";
            }
            action("Text file Import ANSMI")
            {
                Caption = 'Text file Import ANSMI';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "Txt Data ANSMI";
            }
        }
    }
}
