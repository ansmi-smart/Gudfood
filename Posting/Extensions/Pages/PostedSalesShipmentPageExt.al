pageextension 50042 PostedSalesShipmentPageExt extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
