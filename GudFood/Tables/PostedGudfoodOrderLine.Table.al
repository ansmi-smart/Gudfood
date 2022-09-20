table 50019 "Posted Gudfood Order Line"
{
    Caption = 'Posted Gudfood Order Line';
    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Gudfood Order Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            Editable = false;
        }
        field(4; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Gudfood Item".Code;
        }
        field(6; "Item Type"; Option)
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = Lookup("Gudfood Item".Type WHERE(Code = FIELD("Item No.")));
            OptionMembers = "Salat","Burger","Capcake","Drink";
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            MinValue = 0;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(490; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }
    keys
    {
        key(PK; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
