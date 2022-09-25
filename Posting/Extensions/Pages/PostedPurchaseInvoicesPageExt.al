pageextension 50045 PostedPurchaseInvoicesPageExt extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Lines Counter ANSMI"; Rec."Lines Counter ANSMI")
            {
                ApplicationArea = All;
                Editable = false;

            }
        }
    }
}
