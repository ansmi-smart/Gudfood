codeunit 50062 "CSV Uploader ANSMI"
{
    var
        Line: text;
        Buffer: Record "CSV Buffer" temporary;
        ImportURL: Label 'https://integrations.expensify.com/Integration-Server/ExpensifyIntegrations';

    procedure UploadCSV(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        CSVInStream: InStream;
        Filename: Text;
        Row: Integer;
        ImportNtfc: Label 'Import Completed!';
        TempData: Text;
        TempAmount: Decimal;
    begin
        if UploadIntoStream('Choose .csv file for import', '', '', Filename, CSVInStream) then begin
            Buffer.LoadDataFromStream(CSVInStream, ',');
            GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            for Row := 2 to Buffer.GetNumberOfLines() do begin
                GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
                GenJournal.Validate("Line No.", 10000 * (GenJournal.Count + 1));

                TempData := DelChr(GetValue(Row, 1).split(' ').get(1), '=', '"');
                TempData := COPYSTR(TempData, 1, 5) + COPYSTR(TempData, 6, 2) + COPYSTR(TempData, 8, 3);
                Evaluate(GenJournal."Posting Date", TempData);

                GenJournal.Validate("External Document No.", DelChr(GetValue(Row, 2), '=', '"'));
                Evaluate(TempAmount, GetValue(Row, 3));
                GenJournal.Validate("Amount (LCY)", TempAmount);
                GenJournal.Validate(Description, GetValue(Row, 7));
                if (GetValue(Row, 8) = 'yes') then
                    GenJournal.Validate("Reimbursable ANSMI", true)
                else
                    GenJournal.Validate("Reimbursable ANSMI", false);
                GenJournal.Validate("Currency Code", GetValue(Row, 9));
                Evaluate(TempAmount, GetValue(Row, 10));
                GenJournal.Validate(Amount, TempAmount);
                GenJournal.Validate("Receipt ANSMI", GetValue(Row, 11));
                GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
                GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::Vendor);
                GenJournal.Validate("Bal. Account No.", Vendor.GetVendorNo(DelChr(GetValue(Row, 12), '=', '"')));
                GenJournal.Validate("Document No.", 'EXP-' + Format(GenJournal."Posting Date"));
                GenJournal.Insert();
            end;
        end;
        Message(ImportNtfc);
    end;

    procedure GetValue(Row: Integer; FieldNo: Integer): Text
    begin
        if Buffer.Get(Row, FieldNo) then
            exit(Buffer.Value);
    end;

    procedure GetDataFromAPI(Rec: Record "Gen. Journal Line")
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Inst: InStream;
        RequestHttpContent: HttpContent;
        RequestHttpHeaders: HttpHeaders;
        requestJobDescription: Label 'requestJobDescription={"type":"file","credentials":{"partnerUserID":"aa_nastyasmilka_gmail_com","partnerUserSecret":"42979985cc214694934f6d61686ffe95023d12e2"},"onReceive":{"immediateResponse":["returnRandomFileName"]},"inputSettings":{"type":"combinedReportData","filters":{"startDate":"2022-01-01","endDate":"2022-11-01","markedAsExported":"Expensify Export"}},"outputSettings":{"fileExtension":"csv"}}';
        Template: Label '&template=<#-- Header --> <#list reports as report> <#list report.transactionList as expense> ${report.created},<#t> ${expense.merchant},<#t> ${(expense.amount/100)?string("0.00")},<#t> ${expense.comment},<#t> ${expense.reimbursable},<#t> ${expense.currency},<#t> ${(expense.amount/100)?string("0.00")},<#t> ${expense.receipt.url},<#t> ${expense.attendees}<#lt> </#list> </#list>';
        FileName: Text;
        DownloadBody: Label 'requestJobDescription={"type":"download","credentials":{"partnerUserID":"aa_nastyasmilka_gmail_com","partnerUserSecret":"42979985cc214694934f6d61686ffe95023d12e2"},"fileName":"%1"}';
        Row: Integer;
        GenJournal: Record "Gen. Journal Line";
        TempData: Text;
        PostinDate: Date;
        TempAmount: Decimal;
        Vendor: Record Vendor;
        CurrencyCode: Code[20];
    begin
        Client.DefaultRequestHeaders.Add('Accept', 'application/Json');
        RequestHttpContent.Clear();
        RequestHttpContent.WriteFrom(requestJobDescription + Template);
        RequestHttpHeaders.Clear();
        RequestHttpContent.GetHeaders(RequestHttpHeaders);
        RequestHttpHeaders.Remove('Content-Type');
        RequestHttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        RequestHttpContent.GetHeaders(RequestHttpHeaders);

        Client.Post(ImportURL, RequestHttpContent, Response);
        if Response.IsSuccessStatusCode then begin
            Response.Content().ReadAs(Inst);
            Buffer.LoadDataFromStream(Inst, '&');
            FileName := Format(Buffer.Value);
        end;

        Client.DefaultRequestHeaders.Add('Accept', 'application/Json');
        RequestHttpContent.Clear();
        RequestHttpContent.WriteFrom(StrSubstNo(DownloadBody, FileName));
        RequestHttpHeaders.Clear();
        RequestHttpContent.GetHeaders(RequestHttpHeaders);
        RequestHttpHeaders.Remove('Content-Type');
        RequestHttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        RequestHttpContent.GetHeaders(RequestHttpHeaders);
        Client.Post(ImportURL, RequestHttpContent, Response);
        Buffer.FindSet();
        Buffer.DeleteAll();
        if Response.IsSuccessStatusCode then begin
            Response.Content().ReadAs(Inst);
            Buffer.LoadDataFromStream(Inst, '#');
            GenJournal.Init();
            Line := Buffer.Value;
            GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");

            Line := Line.TrimStart();
            TempData := FindValue();
            while (TempData <> '_') do begin
                GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
                GenJournal.Validate("Line No.", 10000 * GenJournal.Count);

                TempData := DelChr(TempData.TrimStart(), '=', ',');
                TempData := COPYSTR(TempData, 1, 5) + COPYSTR(TempData, 6, 2) + COPYSTR(TempData, 8, 3);
                Evaluate(PostinDate, TempData);
                GenJournal.Validate("Posting Date", PostinDate);

                GenJournal.Validate("External Document No.", DelChr(FindValue(), '=', ','));
                Evaluate(TempAmount, DelChr(FindValue(), '=', ','));
                GenJournal."Amount (LCY)" := TempAmount;
                GenJournal.Validate(Description, DelChr(FindValue(), '=', ','));
                if (DelChr(FindValue(), '=', ',') = 'yes') then
                    GenJournal.Validate("Reimbursable ANSMI", true)
                else
                    GenJournal.Validate("Reimbursable ANSMI", false);
                CurrencyCode := DelChr(FindValue(), '=', ',');
                Evaluate(TempAmount, DelChr(FindValue(), '=', ','));
                GenJournal.Validate(Amount, TempAmount);
                GenJournal.Validate("Receipt ANSMI", DelChr(FindValue(), '=', ','));
                GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
                GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::Vendor);
                TempData := FindValue();
                if (TempData = '_') then
                    TempData := ' ';
                GenJournal.Validate("Bal. Account No.", Vendor.GetVendorNoOpenCard(DelChr(TempData, '=', ','), false));
                GenJournal.Validate("Document No.", 'EXP-' + Format(GenJournal."Posting Date"));
                GenJournal.Validate("Currency Code", CurrencyCode);
                GenJournal.insert();
                TempData := FindValue();
            end;
        end;
    end;

    local procedure FindValue(): Text
    var
        Result: Text;
    begin
        if (Line.IndexOf(',') = 0) then
            exit('_')
        else
            if (Line.IndexOf(',') > 10) and (Line.Substring(1, Line.IndexOf(',')).Contains(' 2')) then begin
                Line := Line.TrimStart();
                exit(' ');
            end
            else begin
                Result := Line.Substring(1, Line.IndexOf(','));
                Line := DelStr(Line, 1, Line.IndexOf(','));
                exit(Result);
            end;
    end;
}
