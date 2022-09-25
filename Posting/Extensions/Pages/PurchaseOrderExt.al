pageextension 50055 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Lines Counter ANSMI"; Rec."Lines Counter ANSMI")
            {
                Caption = 'Lines counter ANSMI';
                ApplicationArea = All;
            }
        }
    }
}