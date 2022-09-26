report 50071 "Excel Report"
{
    Caption = 'ANSMI Excel Report';

    dataset
    {
        dataitem("SalesHeader"; "Sales Header")
        {   //company info
            column(CompanyName; CompanyInfo.Name)
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {

            }
            column(CompanyInfo; CompanyInfo."Registration No.")
            {

            }

            //sell-to customer
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoCounty; "Sell-to County")
            {
            }
            column(SelltoCity; "Sell-to City")
            {
            }
            column(SelltoAddress; "Sell-to Address")
            {
            }

            column(SelltoPhoneNo; "Sell-to Phone No.")
            {
            }

            //lines
            dataitem(SalesLines; "Sales Line")
            {
                column("Code"; "No.")
                {

                }
                column(Description; "Description")
                {

                }
                column(Quantity; "Quantity")
                {

                }
                column(UnitPrice; "Unit Price")
                {

                }
                column(LineAmount; "Line Amount")
                {

                }
                column(Amount; Amount)
                {

                }

                //totals
                column(VATAmount; VATAmount)
                {
                    //AmountIncludingVAT-Amount
                }
                column(AmountIncludingVAT; "Amount Including VAT")
                {

                }
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        VATAmount: Decimal;
}
