pageextension 50045 PostedPurchaseInvoicesPageExt extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
            }
        }
        addafter("Cust. Post. Description ANSMI")
        {
            field("Lines Counter ANSMI"; Rec."Lines Counter ANSMI")
            {
                ApplicationArea = All;

            }
        }
    }
}
