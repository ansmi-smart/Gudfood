tableextension 50050 SalesShipmentHeaderExt extends "Sales Shipment Header"
{
    fields
    {
        field(50030; "Cust. Post. Description ANSMI"; Text[50])
        {
            Caption = 'Custom Posting Description ANSMI';
            DataClassification = ToBeClassified;
        }
    }
}
