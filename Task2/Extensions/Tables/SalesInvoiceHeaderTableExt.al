tableextension 50033 SalesInvoiceHeaderTableExt extends "Sales Invoice Header"
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
