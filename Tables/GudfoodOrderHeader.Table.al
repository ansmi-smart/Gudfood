table 50015 "Gudfood Order Header"
{
    Caption = 'Gudfood Order Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'No';

            trigger OnValidate()
            begin
                IF No <> xRec.No THEN BEGIN
                    SalesReceivablesSetup.GET;
                    NoSeriesMgt.TestManual(SalesReceivablesSetup."Gudfood Order Nos.");
                    "Posting No." := '';
                END;

                CreateDim(
                    DATABASE::Customer, "Sell- to Customer No.",
                    DATABASE::"Gudfood Order Header", No);

            end;
        }
        field(2; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF "Sell- to Customer No." <> '' THEN BEGIN
                    Customer.GET("Sell- to Customer No.");
                    "Sell- to Customer Name" := Customer.Name;
                END ELSE
                    "Sell- to Customer Name" := '';
            end;
        }
        field(3; "Sell- to Customer Name"; Text[100])
        {
            Caption = 'Sell- to Customer Name';
            Editable = false;
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(5; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';

            trigger OnValidate()
            begin
                "Date Created" := System.Today;
            end;
        }
        field(7; "Total Qty"; Decimal)
        {
            Caption = 'Total Qty';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Gudfood Order Line".Quantity WHERE("Order No." = FIELD(No)));
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Gudfood Order Line".Amount WHERE("Order No." = FIELD(No)));
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
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
                ShowDocDim();
            end;
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        DimMgt: Codeunit "DimensionManagement";
        GudfoodOrderLine: Record "Gudfood Order Line";

    trigger OnInsert()
    begin
        "Date Created" := System.Today;
        IF No = '' THEN BEGIN
            SalesReceivablesSetup.GET;
            NoSeriesMgt.InitSeries(SalesReceivablesSetup."Gudfood Order Nos.", xRec."Posting No.", 0D, No, "Posting No.");
        END;
    end;

    trigger OnDelete()
    begin
        GudfoodOrderLine.SETFILTER("Order No.", Rec.No);
        GudfoodOrderLine.FINDSET;
        REPEAT
            GudfoodOrderLine.DELETE;
        UNTIL GudfoodOrderLine.NEXT = 0;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF No <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF GudFoodLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateShortcutDimCode(VAR GudfoodOrderHeader: Record "Gudfood Order Header"; xGudfoodOrderHeader: Record "Gudfood Order Header"; FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
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

        GudfoodOrderLine.RESET;
        GudfoodOrderLine.SETRANGE(GudfoodOrderLine."Order No.", No);
        GudfoodOrderLine.LOCKTABLE;
        IF GudfoodOrderLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(GudfoodOrderLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF GudfoodOrderLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    GudfoodOrderLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      GudfoodOrderLine."Dimension Set ID", GudfoodOrderLine."Shortcut Dimension 1 Code", GudfoodOrderLine."Shortcut Dimension 2 Code");

                    OnUpdateAllLineDimOnBeforeSalesLineModify(GudfoodOrderLine);
                    GudfoodOrderLine.MODIFY;
                END;
            UNTIL GudfoodOrderLine.NEXT = 0;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnUpdateAllLineDimOnBeforeSalesLineModify(VAR GudfoodOrderLine: Record "Gudfood Order Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUpdateAllLineDim(VAR GudfoodOrderHeader: Record "Gudfood Order Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; VAR IsHandled: Boolean)
    begin
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
         DimMgt.GetRecDefaultDimID(
           Rec, CurrFieldNo, TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        OnCreateDimOnBeforeUpdateLines(Rec, xRec, CurrFieldNo);
        GudfoodOrderLine.RESET;
        IF (OldDimSetID <> "Dimension Set ID") AND GudFoodLinesExist THEN BEGIN
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;


    local procedure GudFoodLinesExist(): Boolean
    begin
        GudfoodOrderLine.RESET;
        GudfoodOrderLine.SETRANGE(GudfoodOrderLine."Order No.", No);
        EXIT(NOT GudfoodOrderLine.ISEMPTY);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnCreateDimOnBeforeUpdateLines(VAR GudfoodOrderHeader: Record "Gudfood Order Header"; xGudfoodOrderHeader: Record "Gudfood Order Header"; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCreateDimTableIDs(VAR GudfoodOrderHeader: Record "Gudfood Order Header"; CallingFieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR Code: ARRAY[10] OF Code[20])
    begin
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
         DimMgt.EditDimensionSet(
           "Dimension Set ID", STRSUBSTNO('%1', No),
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF GudFoodLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

}
