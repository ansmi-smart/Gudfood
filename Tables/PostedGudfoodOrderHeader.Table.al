table 50018 "Posted Gudfood Order Header"
{
    Caption = 'Posted Gudfood Order Header';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No';
        }
        field(2; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            TableRelation = Customer."No.";
        }
        field(3; "Sell- to Customer Name"; Text[100])
        {
            Caption = 'Sell- to Customer Name';
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(5; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';

            trigger OnValidate()
            begin
                IF "Posting No." <> xRec."Posting No." THEN BEGIN
                    SalesReceivablesSetup.GET;
                    NoSeriesMgt.TestManual(SalesReceivablesSetup."Posted Gudfood Item Nos.");
                    "No." := '';
                END;
            end;
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(7; "Total Qty"; Decimal)
        {
            Caption = 'Total Qty';
            FieldClass = FlowField;
            CalcFormula = Sum("Gudfood Order Line".Quantity WHERE("Order No." = FIELD("No.")));
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Gudfood Order Line".Amount WHERE("Order No." = FIELD("No.")));
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
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
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        IF "Posting No." = '' THEN BEGIN
            SalesReceivablesSetup.GET;
            NoSeriesMgt.InitSeries(SalesReceivablesSetup."Posted Gudfood Item Nos.", Rec."No.", 0D, "Posting No.", xRec."No.");
        END;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        DimMgt: Codeunit "DimensionManagement";
        PostedGudfoodOrderLine: Record "Posted Gudfood Order Line";

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
         DimMgt.EditDimensionSet(
           "Dimension Set ID", STRSUBSTNO('%1', "No."),
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF PostedGudFoodLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        ShippedReceivedItemLineDimChangeConfirmed: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeUpdateAllLineDim(Rec, NewParentDimSetID, OldParentDimSetID, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;

        PostedGudfoodOrderLine.RESET;
        PostedGudfoodOrderLine.SETRANGE(PostedGudfoodOrderLine."Order No.", "No.");
        PostedGudfoodOrderLine.LOCKTABLE;
        IF PostedGudfoodOrderLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(PostedGudfoodOrderLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF PostedGudfoodOrderLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    PostedGudfoodOrderLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PostedGudfoodOrderLine."Dimension Set ID", PostedGudfoodOrderLine."Shortcut Dimension 1 Code", PostedGudfoodOrderLine."Shortcut Dimension 2 Code");

                    OnUpdateAllLineDimOnBeforeSalesLineModify(PostedGudfoodOrderLine);
                    PostedGudfoodOrderLine.MODIFY;
                END;
            UNTIL PostedGudfoodOrderLine.NEXT = 0;
    end;

    local procedure PostedGudFoodLinesExist(): Boolean
    begin
        PostedGudfoodOrderLine.RESET;
        PostedGudfoodOrderLine.SETRANGE(PostedGudfoodOrderLine."Order No.", "No.");
        EXIT(NOT PostedGudfoodOrderLine.ISEMPTY);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUpdateAllLineDim(VAR PostedGudfoodOrderHeader: Record "Posted Gudfood Order Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; VAR IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnUpdateAllLineDimOnBeforeSalesLineModify(VAR PostedGudfoodOrderLine: Record "Posted Gudfood Order Line")
    begin
    end;
}
