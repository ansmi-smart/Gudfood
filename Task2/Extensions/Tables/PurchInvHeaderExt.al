tableextension 50047 PurchInvHeaderExt extends "Purch. Inv. Header"
{
    fields
    {
        field(50030; "Cust. Post. Description ANSMI"; Text[50])
        {
            Caption = 'Custom Posting Description ANSMI';
            DataClassification = ToBeClassified;
        }
        field(50031; "Lines Counter ANSMI"; Integer)
        {
            Caption = 'Lines Counter ANSMI';
            FieldClass = Normal;
        }

    }
}
