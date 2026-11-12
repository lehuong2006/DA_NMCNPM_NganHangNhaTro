document.addEventListener("DOMContentLoaded", function () {

    const invoiceTableBody = document.getElementById(
        "tenantInvoicesTableBody"
    );

    const emptyMessage = document.querySelector(
        ".tenant-invoices-empty"
    );

    // Hiển thị trạng thái khi chưa có hóa đơn
    function updateEmptyState() {

        if (!invoiceTableBody || !emptyMessage) {
            return;
        }

        const hasInvoices =
            invoiceTableBody.querySelector("tr") !== null;

        emptyMessage.hidden = hasInvoices;

    }

    updateEmptyState();

});
