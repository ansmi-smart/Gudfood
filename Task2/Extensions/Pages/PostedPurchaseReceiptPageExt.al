pageextension 50058 PostedPurchaseReceiptPageExt extends "Posted Purchase Receipt"
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
