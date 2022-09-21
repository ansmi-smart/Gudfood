codeunit 50002 ActionModify
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        GenJournalLine."Cust. Post. Description ANSMI" := SalesHeader."Cust. Post. Description ANSMI";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnPostCustOnAfterInitCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry"; Cust: Record Customer; CustPostingGr: Record "Customer Posting Group")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualCheckAndRelease', '', false, false)]
    procedure OnBeforePerformManualCheckAndRelease(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Cust. Post. Description ANSMI" = '' then
            Error(AddDescriptionMessage);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPostPurchase()
    begin
        PurchInvHeader."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
        PurchaceReceipt."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
    end;

    var
        AddDescriptionMessage: Label 'Cust. Post. Description ANSM can`t be empty!';
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaceReceipt: Record "Purch. Rcpt. Header";
}