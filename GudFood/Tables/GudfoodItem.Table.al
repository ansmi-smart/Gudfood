table 50011 "Gudfood Item"
{
    Caption = 'Gudfood Item';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                IF Code <> xRec.Code THEN BEGIN
                    SalesReceivablesSetup.GET;
                    NoSeriesMgt.TestManual(SalesReceivablesSetup."Gudfood Item Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(4; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Salat","Burger","Capcake","Drink";
        }
        field(5; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
            FieldClass = FlowField;
            CalcFormula = Sum("Posted Gudfood Order Line".Quantity WHERE("Item No." = FIELD(Code)));
        }
        field(6; "Qty. in Order"; Decimal)
        {
            Caption = 'Qty. in Order';
            FieldClass = FlowField;
            CalcFormula = Sum("Gudfood Order Line".Quantity WHERE("Item No." = FIELD(Code)));
        }
        field(7; "Shelf Life"; Date)
        {
            Caption = 'Shelf Life';

        }
        field(8; Picture; Media)
        {
            Caption = 'Picture';
        }
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        DimMgt: Codeunit "DimensionManagement";

    trigger OnInsert()
    begin
        if Code = '' then begin
            SalesReceivablesSetup.GET;
            SalesReceivablesSetup.TESTFIELD("Gudfood Item Nos.");
            NoSeriesMgt.InitSeries(
                SalesReceivablesSetup."Gudfood Item Nos.",
                xRec.Code, 0D, Code, "No. Series");
        end;
        DimMgt.UpdateDefaultDim(50011, Code,
            "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(50011, Code);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeValidateShortcutDimCode(Rec, FieldNumber, ShortcutDimCode, IsHandled);
        IF IsHandled THEN
            EXIT;

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        IF NOT ISTEMPORARY THEN BEGIN
            DimMgt.SaveDefaultDim(50011, Code, FieldNumber, ShortcutDimCode);
            MODIFY;
        END;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeValidateShortcutDimCode(VAR GudfoodItem: Record "Gudfood Item"; FieldNumber: Integer; VAR ShortcutDimCode: Code[20]; VAR IsHandled: Boolean)
    begin
    end;

}
