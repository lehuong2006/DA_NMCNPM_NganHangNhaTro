document.addEventListener("DOMContentLoaded", function () {

    const billingPeriod = document.getElementById("billingPeriod");
    const invoiceStatus = document.getElementById("invoiceStatus");
    const invoiceSearch = document.getElementById("invoiceSearch");

    const invoiceTableBody = document.getElementById("invoiceTableBody");
    const invoiceEmpty = document.querySelector(".invoice-empty");

    const previewStatus = document.querySelector(".preview-status");

    const previewInvoiceCode = document.getElementById("previewInvoiceCode");
    const previewCreatedDate = document.getElementById("previewCreatedDate");
    const previewBillingPeriod = document.getElementById("previewBillingPeriod");

    const previewTenant = document.getElementById("previewTenant");
    const previewRoom = document.getElementById("previewRoom");
    const previewDueDate = document.getElementById("previewDueDate");

    const receiptItems = document.getElementById("receiptItems");
    const previewTotal = document.getElementById("previewTotal");
    const previewAmountWords = document.getElementById("previewAmountWords");

    const printReceiptButton = document.getElementById("printReceiptButton");
    const downloadPdfButton = document.getElementById("downloadPdfButton");

    function formatMoney(value) {
        const amount = Number(value || 0);

        return amount.toLocaleString("vi-VN");
    }

    function formatDate(value) {
        if (!value) {
            return "—";
        }

        const parts = value.split("-");

        if (parts.length !== 3) {
            return value;
        }

        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    function filterInvoices() {

        const searchValue = invoiceSearch.value.trim().toLowerCase();
        const selectedPeriod = billingPeriod.value;
        const selectedStatus = invoiceStatus.value;

        const rows = invoiceTableBody.querySelectorAll(".invoice-row");

        let visibleCount = 0;

        rows.forEach(function (row) {

            const room = (row.dataset.room || "").toLowerCase();
            const tenant = (row.dataset.tenant || "").toLowerCase();

            const period = row.dataset.period || "";
            const status = row.dataset.status || "";

            const matchesSearch =
                room.includes(searchValue) ||
                tenant.includes(searchValue);

            const matchesPeriod =
                selectedPeriod === "" || period === selectedPeriod;

            const matchesStatus =
                selectedStatus === "" || status === selectedStatus;

            const isVisible =
                matchesSearch && matchesPeriod && matchesStatus;

            row.style.display = isVisible ? "" : "none";

            if (isVisible) {
                visibleCount++;
            }

        });

        invoiceEmpty.style.display =
            visibleCount === 0 ? "flex" : "none";

        if (visibleCount === 0) {
            clearPreview();
        }

    }

    invoiceSearch.addEventListener("input", filterInvoices);
    billingPeriod.addEventListener("change", filterInvoices);
    invoiceStatus.addEventListener("change", filterInvoices);

    function clearPreview() {

        previewStatus.textContent = "Chưa chọn";

        previewInvoiceCode.textContent = "—";
        previewCreatedDate.textContent = "—";
        previewBillingPeriod.textContent = "—";

        previewTenant.textContent = "—";
        previewRoom.textContent = "—";
        previewDueDate.textContent = "—";

        previewTotal.textContent = "0";
        previewAmountWords.textContent = "—";

        receiptItems.innerHTML = "";

        const emptyMessage = document.createElement("div");
        emptyMessage.className = "receipt-item-empty";
        emptyMessage.textContent = "Chọn một hóa đơn để xem chi tiết.";

        receiptItems.appendChild(emptyMessage);

    }

    function showInvoicePreview(row) {

        const rows = invoiceTableBody.querySelectorAll(".invoice-row");

        rows.forEach(function (item) {
            item.classList.remove("selected");
        });

        row.classList.add("selected");

        const status = row.dataset.status || "";

        previewStatus.textContent =
            status === "paid"
                ? "Đã thanh toán"
                : status === "partial"
                    ? "Còn nợ"
                    : "Chưa thanh toán";

        previewInvoiceCode.textContent =
            row.dataset.code || "—";

        previewCreatedDate.textContent =
            formatDate(row.dataset.createdDate);

        previewBillingPeriod.textContent =
            row.dataset.period || "—";

        previewTenant.textContent =
            row.dataset.tenant || "—";

        previewRoom.textContent =
            row.dataset.room || "—";

        previewDueDate.textContent =
            formatDate(row.dataset.dueDate);

        previewTotal.textContent =
            formatMoney(row.dataset.total);

        previewAmountWords.textContent =
            row.dataset.amountWords || "—";


        // Lấy các khoản phí được render trong dòng hóa đơn
        const items = row.querySelectorAll(".invoice-item-data");

        receiptItems.innerHTML = "";

        if (items.length === 0) {

            const emptyMessage = document.createElement("div");
            emptyMessage.className = "receipt-item-empty";
            emptyMessage.textContent =
                "Chưa có chi tiết khoản phí.";

            receiptItems.appendChild(emptyMessage);

        } else {

            items.forEach(function (item) {

                const itemRow = document.createElement("div");
                itemRow.className = "receipt-item";

                const itemName = document.createElement("span");
                itemName.textContent = item.dataset.name || "";

                const itemAmount = document.createElement("strong");
                itemAmount.textContent =
                    formatMoney(item.dataset.amount);

                itemRow.appendChild(itemName);
                itemRow.appendChild(itemAmount);

                receiptItems.appendChild(itemRow);

            });

        }

    }

    invoiceTableBody.addEventListener("click", function (event) {

        const actionButton = event.target.closest(
            ".invoice-action-button"
        );

        if (actionButton) {
            event.stopPropagation();
            return;
        }

        const row = event.target.closest(".invoice-row");

        if (!row || row.style.display === "none") {
            return;
        }

        showInvoicePreview(row);

    });

    printReceiptButton.addEventListener("click", function () {

        const selectedRow =
            invoiceTableBody.querySelector(".invoice-row.selected");

        if (!selectedRow) {
            alert("Vui lòng chọn hóa đơn trước khi in phiếu thu.");
            return;
        }

        window.print();

    });

    downloadPdfButton.addEventListener("click", function () {

        alert("Chức năng tải PDF sẽ được tích hợp sau.");

    });

    clearPreview();
    filterInvoices();

});
