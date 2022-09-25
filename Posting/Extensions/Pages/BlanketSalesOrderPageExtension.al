pageextension 50034 BlanketSalesOrderPageExtension extends "Blanket Sales Order"
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
    }
}
