table 50016 "Gudfood Order Line"
{
    Caption = 'Gudfood Order Line';

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
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
            Editable = false;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Gudfood Item".Code;

            trigger OnValidate()
            begin
                IF "Item No." <> '' THEN BEGIN
                    GudfoodItem.GET("Item No.");
                    "Item Type" := GudfoodItem.Type;
                    Description := GudfoodItem.Description;
                    "Unit Price" := GudfoodItem."Unit Price";
                    IF GudfoodItem."Shelf Life" < TODAY THEN
                        ERROR('Item is expired!');
                    CreateDim(
                    DATABASE::Customer, "Sell- to Customer No.",
                    DATABASE::"Gudfood Item", "Item No.");

                END ELSE BEGIN
                    "Item Type" := "Item Type"::Salat;
                    Description := '';
                    "Unit Price" := 0;
                END;

            end;
        }
        field(6; "Item Type"; Option)
        {
            Caption = 'Item Type';
            InitValue = " ";
            FieldClass = FlowField;
            CalcFormula = Lookup("Gudfood Item".Type WHERE(Code = FIELD("Item No.")));
            OptionMembers = "Salat","Burger","Capcake","Drink"," ";
            Editable = false;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            MinValue = 0;
            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
            end;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;

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

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
    }
    keys
    {
        key(PK; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        GudfoodOrderHeader: Record "Gudfood Order Header";
        GudfoodItem: Record "Gudfood Item";
        GudfoodOrderLine: Record "Gudfood Order Line";
        DimMgt: Codeunit "DimensionManagement";


    trigger OnInsert()
    begin
        IF "Order No." <> '' THEN BEGIN
            GudfoodOrderHeader.GET("Order No.");
            "Sell- to Customer No." := GudfoodOrderHeader."Sell- to Customer No.";
            "Date Created" := GudfoodOrderHeader."Date Created";
        END ELSE BEGIN
            "Sell- to Customer No." := '';
            "Date Created" := 0D;
        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);


        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, TableID, No, SourceCodeSetup.Sales,
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", GudfoodOrderHeader."Dimension Set ID", 50011);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCreateDimTableIDs(VAR GudfoodOrderLine: Record "Gudfood Order Line"; CallingFieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR Code: ARRAY[10] OF Code[20])
    begin
    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', "Order No.", "Line No."));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
