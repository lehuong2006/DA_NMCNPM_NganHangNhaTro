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

    // Modal elements
    const createModal = document.getElementById("createInvoiceModal");
    const openModalBtn = document.getElementById("openCreateInvoiceModalBtn");
    const closeModalBtn = document.getElementById("closeCreateInvoiceModalBtn");
    const cancelModalBtn = document.getElementById("cancelModalBtn");
    const saveInvoiceModalBtn = document.getElementById("saveInvoiceModalBtn");

    const modalRoomSelect = document.getElementById("modalRoomSelect");
    const modalMonthYear = document.getElementById("modalMonthYear");
    const modalDueDate = document.getElementById("modalDueDate");
    const modalRoomFee = document.getElementById("modalRoomFee");
    const modalElecFee = document.getElementById("modalElecFee");
    const modalWaterFee = document.getElementById("modalWaterFee");
    const modalServiceFee = document.getElementById("modalServiceFee");

    function formatMoney(value) {
        const amount = Number(value || 0);
        return amount.toLocaleString("vi-VN");
    }

    function formatDate(value) {
        if (!value) return "—";
        const parts = value.split("-");
        if (parts.length !== 3) return value;
        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    function filterInvoices() {
        if (!invoiceTableBody) return;
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

        if (invoiceEmpty) {
            invoiceEmpty.style.display = visibleCount === 0 ? "flex" : "none";
        }

        if (visibleCount === 0) {
            clearPreview();
        }
    }

    if (invoiceSearch) invoiceSearch.addEventListener("input", filterInvoices);
    if (billingPeriod) billingPeriod.addEventListener("change", filterInvoices);
    if (invoiceStatus) invoiceStatus.addEventListener("change", filterInvoices);

    function clearPreview() {
        if (!previewStatus) return;
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

        previewInvoiceCode.textContent = row.dataset.code || "—";
        previewCreatedDate.textContent = formatDate(row.dataset.createdDate);
        previewBillingPeriod.textContent = row.dataset.period || "—";
        previewTenant.textContent = row.dataset.tenant || "—";
        previewRoom.textContent = row.dataset.room || "—";
        previewDueDate.textContent = formatDate(row.dataset.dueDate);
        previewTotal.textContent = formatMoney(row.dataset.total);
        previewAmountWords.textContent = row.dataset.amountWords || "—";

        // Lấy các khoản phí được render trong dòng hóa đơn
        const items = row.querySelectorAll(".invoice-item-data");
        receiptItems.innerHTML = "";

        if (items.length === 0) {
            const emptyMessage = document.createElement("div");
            emptyMessage.className = "receipt-item-empty";
            emptyMessage.textContent = "Chưa có chi tiết khoản phí.";
            receiptItems.appendChild(emptyMessage);
        } else {
            items.forEach(function (item) {
                const itemRow = document.createElement("div");
                itemRow.className = "receipt-item";

                const itemName = document.createElement("span");
                itemName.textContent = item.dataset.name || "";

                const itemAmount = document.createElement("strong");
                itemAmount.textContent = formatMoney(item.dataset.amount) + " đ";

                itemRow.appendChild(itemName);
                itemRow.appendChild(itemAmount);
                receiptItems.appendChild(itemRow);
            });
        }
    }

    if (invoiceTableBody) {
        invoiceTableBody.addEventListener("click", function (event) {
            const row = event.target.closest(".invoice-row");
            if (!row || row.style.display === "none") {
                return;
            }
            showInvoicePreview(row);
        });

        // Tự động chọn hóa đơn đầu tiên nếu có
        const firstRow = invoiceTableBody.querySelector(".invoice-row");
        if (firstRow) {
            showInvoicePreview(firstRow);
        }
    }

    if (printReceiptButton) {
        printReceiptButton.addEventListener("click", function () {
            const selectedRow = invoiceTableBody ? invoiceTableBody.querySelector(".invoice-row.selected") : null;
            if (!selectedRow) {
                alert("Vui lòng chọn hóa đơn trước khi in phiếu thu.");
                return;
            }
            window.print();
        });
    }

    if (downloadPdfButton) {
        downloadPdfButton.addEventListener("click", function () {
            alert("Chức năng tải PDF: Bạn có thể chọn In phiếu thu -> Lưu dưới dạng PDF.");
            window.print();
        });
    }

    // ==========================================
    // LOGIC MODAL TẠO HÓA ĐƠN CHO PHÒNG
    // ==========================================
    if (openModalBtn && createModal) {
        openModalBtn.addEventListener("click", function () {
            createModal.classList.add("active");
        });
    }

    function closeModal() {
        if (createModal) createModal.classList.remove("active");
    }

    if (closeModalBtn) closeModalBtn.addEventListener("click", closeModal);
    if (cancelModalBtn) cancelModalBtn.addEventListener("click", closeModal);

    // Tự động điền giá phòng khi chọn phòng
    if (modalRoomSelect) {
        modalRoomSelect.addEventListener("change", function () {
            const opt = modalRoomSelect.options[modalRoomSelect.selectedIndex];
            if (opt && opt.value) {
                const price = opt.dataset.price;
                if (price && modalRoomFee) {
                    modalRoomFee.value = Number(price).toLocaleString("vi-VN");
                }
            }
        });
    }

    // Format tiền trong modal inputs
    [modalRoomFee, modalElecFee, modalWaterFee, modalServiceFee].forEach(function (inp) {
        if (!inp) return;
        inp.addEventListener("input", function () {
            const digits = inp.value.replace(/\D/g, "");
            inp.value = digits === "" ? "" : Number(digits).toLocaleString("vi-VN");
        });
    });

    if (saveInvoiceModalBtn) {
        saveInvoiceModalBtn.addEventListener("click", async function () {
            if (!modalRoomSelect.value) {
                alert("Vui lòng chọn phòng cần tạo hóa đơn.");
                modalRoomSelect.focus();
                return;
            }

            const roomFeeVal = Number((modalRoomFee.value || "").replace(/\D/g, "")) || 0;
            const elecFeeVal = Number((modalElecFee.value || "").replace(/\D/g, "")) || 0;
            const waterFeeVal = Number((modalWaterFee.value || "").replace(/\D/g, "")) || 0;
            const serviceFeeVal = Number((modalServiceFee.value || "").replace(/\D/g, "")) || 0;

            const payload = {
                roomId: Number(modalRoomSelect.value),
                monthYear: modalMonthYear.value,
                dueDate: modalDueDate.value,
                roomFee: roomFeeVal,
                elecFee: elecFeeVal,
                waterFee: waterFeeVal,
                serviceFee: serviceFeeVal
            };

            saveInvoiceModalBtn.disabled = true;
            saveInvoiceModalBtn.textContent = "Đang tạo...";

            try {
                const res = await fetch("/Landlord/CreateInvoiceForRoom", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(payload)
                });
                const data = await res.json();
                if (data.success) {
                    alert(data.message || "Tạo hóa đơn thành công!");
                    window.location.reload();
                } else {
                    alert(data.message || "Không thể tạo hóa đơn.");
                }
            } catch (err) {
                console.error(err);
                alert("Đã xảy ra lỗi khi tạo hóa đơn.");
            } finally {
                saveInvoiceModalBtn.disabled = false;
                saveInvoiceModalBtn.textContent = "Tạo hóa đơn";
            }
        });
    }

});
