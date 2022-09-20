pageextension 50056 BlanketPurchaseOrderExt extends "Blanket Purchase Order"
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