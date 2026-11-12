document.addEventListener("DOMContentLoaded", function () {

    const walletTabs = document.querySelectorAll(".wallet-tab");
    const walletTabContents = document.querySelectorAll(".wallet-tab-content");

    const walletWorkspace = document.querySelector(".wallet-workspace");
    const walletDetailPanel = document.querySelector(".wallet-detail-panel");

    const topupTableBody = document.getElementById("topupTableBody");
    const historyTableBody = document.getElementById("historyTableBody");
    const debtTableBody = document.getElementById("debtTableBody");
    const autoDeductTableBody = document.getElementById("autoDeductTableBody");

    const rejectButton = document.getElementById("rejectButton");
    const approveButton = document.getElementById("approveButton");
    const rejectReason = document.getElementById("rejectReason");

    const receiptImage = document.getElementById("receiptImage");
    const receiptImagePlaceholder = document.getElementById(
        "receiptImagePlaceholder"
    );

    const transactionType = document.getElementById("transactionType");
    const transactionStartDate = document.getElementById("transactionStartDate");
    const transactionEndDate = document.getElementById("transactionEndDate");
    const debtStatus = document.getElementById("debtStatus");
    const debtPeriod = document.getElementById("debtPeriod");
    const debtRoom = document.getElementById("debtRoom");
    const totalDebtAmount = document.getElementById("totalDebtAmount");
    // Trừ tiền tự động
    const autoDeductEnabled = document.getElementById("autoDeductEnabled");
    const deductDay = document.getElementById("deductDay");
    const toggleStatus = document.getElementById("toggleStatus");
    const runDeductButton = document.getElementById("runDeductButton");

    const detailElements = {
        code: document.getElementById("detailRequestCode"),
        tenant: document.getElementById("detailTenant"),
        room: document.getElementById("detailRoom"),
        amount: document.getElementById("detailAmount"),
        transactionCode: document.getElementById("detailTransactionCode"),
        createdAt: document.getElementById("detailCreatedAt")
    };

    const detailStatus = document.querySelector(".detail-status");

    function formatMoney(value) {
        const amount = Number(value || 0);

        return amount.toLocaleString("vi-VN") + " VNĐ";
    }

    const tabMap = {
        topup: "topupTab",
        history: "historyTab",
        debt: "debtTab",
        "auto-deduct": "autoDeductTab"
    };

    function switchTab(selectedTab) {

        walletTabs.forEach(function (tab) {

            const isActive = tab.dataset.tab === selectedTab;

            tab.classList.toggle("active", isActive);
            tab.setAttribute("aria-selected", String(isActive));

        });

        walletTabContents.forEach(function (content) {
            content.hidden = content.id !== tabMap[selectedTab];
            content.classList.toggle(
                "active",
                content.id === tabMap[selectedTab]
            );
        });

        // Chỉ hiện bảng chi tiết yêu cầu nạp tiền ở tab tương ứng
        walletDetailPanel.hidden = selectedTab !== "topup";

        walletWorkspace.classList.toggle(
            "detail-hidden",
            selectedTab !== "topup"
        );

        clearTopupSelection();

    }

    walletTabs.forEach(function (tab) {

        tab.addEventListener("click", function () {
            switchTab(tab.dataset.tab);
        });

    });

    function clearTopupSelection() {

        const selectedRows = topupTableBody.querySelectorAll(
            ".topup-row.selected"
        );

        selectedRows.forEach(function (row) {
            row.classList.remove("selected");
        });

        detailElements.code.textContent = "—";
        detailElements.tenant.textContent = "—";
        detailElements.room.textContent = "—";
        detailElements.amount.textContent = "—";
        detailElements.transactionCode.textContent = "—";
        detailElements.createdAt.textContent = "—";

        detailStatus.textContent = "Chưa chọn";

        receiptImage.removeAttribute("src");
        receiptImage.hidden = true;
        receiptImagePlaceholder.hidden = false;

        rejectReason.value = "";

        approveButton.disabled = true;
        rejectButton.disabled = true;

    }

    function showTopupDetail(row) {

        const rows = topupTableBody.querySelectorAll(".topup-row");

        rows.forEach(function (item) {
            item.classList.remove("selected");
        });

        row.classList.add("selected");

        detailElements.code.textContent =
            row.dataset.code || "—";

        detailElements.tenant.textContent =
            row.dataset.tenant || "—";

        detailElements.room.textContent =
            row.dataset.room || "—";

        detailElements.amount.textContent =
            formatMoney(row.dataset.amount);

        detailElements.transactionCode.textContent =
            row.dataset.transactionCode || "—";

        detailElements.createdAt.textContent =
            row.dataset.createdAt || "—";

        detailStatus.textContent = "Chờ duyệt";

        // Hiển thị chứng từ nếu có đường dẫn ảnh
        const imageUrl = row.dataset.receiptImage || "";

        if (imageUrl) {

            receiptImage.src = imageUrl;
            receiptImage.hidden = false;
            receiptImagePlaceholder.hidden = true;

        } else {

            receiptImage.removeAttribute("src");
            receiptImage.hidden = true;
            receiptImagePlaceholder.hidden = false;

        }

        approveButton.disabled = false;
        rejectButton.disabled = false;

    }

    topupTableBody.addEventListener("click", function (event) {

        const row = event.target.closest(".topup-row");

        if (!row) {
            return;
        }

        showTopupDetail(row);

    });

    approveButton.addEventListener("click", function () {

        const selectedRow =
            topupTableBody.querySelector(".topup-row.selected");

        if (!selectedRow) {
            alert("Vui lòng chọn yêu cầu nạp tiền.");
            return;
        }

        const confirmed = confirm(
            "Bạn có chắc chắn muốn phê duyệt yêu cầu nạp tiền này?"
        );

        if (!confirmed) {
            return;
        }

        alert(
            "Đã kiểm tra thao tác. Chức năng phê duyệt và cộng tiền vào ví sẽ được tích hợp backend sau."
        );

    });

    rejectButton.addEventListener("click", function () {

        const selectedRow =
            topupTableBody.querySelector(".topup-row.selected");

        if (!selectedRow) {
            alert("Vui lòng chọn yêu cầu nạp tiền.");
            return;
        }

        const reason = rejectReason.value.trim();

        if (!reason) {
            alert("Vui lòng nhập lý do từ chối.");
            rejectReason.focus();
            return;
        }

        const confirmed = confirm(
            "Bạn có chắc chắn muốn từ chối yêu cầu này?"
        );

        if (!confirmed) {
            return;
        }

        alert(
            "Đã kiểm tra thao tác. Chức năng từ chối yêu cầu sẽ được tích hợp backend sau."
        );

    });

    function filterHistory() {

        const selectedType = transactionType.value;
        const startDate = transactionStartDate.value;
        const endDate = transactionEndDate.value;

        if (startDate && endDate && startDate > endDate) {
            alert("Ngày bắt đầu không được lớn hơn ngày kết thúc.");
            transactionEndDate.value = "";
            return;
        }

        const rows = historyTableBody.querySelectorAll(".history-row");

        let visibleCount = 0;

        rows.forEach(function (row) {

            const type = row.dataset.type || "";
            const transactionDate = row.dataset.date || "";

            const matchesType =
                selectedType === "" || type === selectedType;

            const matchesStartDate =
                startDate === "" || transactionDate >= startDate;

            const matchesEndDate =
                endDate === "" || transactionDate <= endDate;

            const isVisible =
                matchesType && matchesStartDate && matchesEndDate;

            row.style.display = isVisible ? "" : "none";

            if (isVisible) {
                visibleCount++;
            }

        });

        updateEmptyState(historyTableBody, visibleCount);

    }

    transactionType.addEventListener("change", filterHistory);
    transactionStartDate.addEventListener("change", filterHistory);
    transactionEndDate.addEventListener("change", filterHistory);


    transactionType.addEventListener("change", filterHistory);
    transactionPeriod.addEventListener("change", filterHistory);

    function filterDebts() {

        const selectedStatus = debtStatus.value;
        const selectedPeriod = debtPeriod.value;
        const selectedRoom = debtRoom.value;

        const rows = debtTableBody.querySelectorAll(".debt-row");

        let visibleCount = 0;
        let totalDebt = 0;

        rows.forEach(function (row) {

            const status = row.dataset.status || "";
            const period = row.dataset.period || "";
            const room = row.dataset.room || "";

            const amount = Number(row.dataset.amount || 0);

            const matchesStatus =
                selectedStatus === "" || status === selectedStatus;

            const matchesPeriod =
                selectedPeriod === "" || period === selectedPeriod;

            const matchesRoom =
                selectedRoom === "" || room === selectedRoom;

            const isVisible =
                matchesStatus && matchesPeriod && matchesRoom;

            row.style.display = isVisible ? "" : "none";

            if (isVisible) {

                visibleCount++;

                if (status !== "RESOLVED") {
                    totalDebt += amount;
                }

            }

        });

        totalDebtAmount.textContent =
            totalDebt.toLocaleString("vi-VN") + " đ";

        updateEmptyState(debtTableBody, visibleCount);

    }

    debtStatus.addEventListener("change", filterDebts);
    debtPeriod.addEventListener("change", filterDebts);
    debtRoom.addEventListener("change", filterDebts);

    // HÀNH ĐỘNG CÔNG NỢ
    debtTableBody.addEventListener("click", function (event) {

        const reminderButton = event.target.closest(
            ".debt-action-button.remind"
        );

        const retryButton = event.target.closest(
            ".debt-action-button.retry"
        );

        const row = event.target.closest(".debt-row");

        if (!row) {
            return;
        }

        if (reminderButton) {

            const tenantName = row.dataset.tenant || "người thuê";

            alert(
                "Chức năng gửi nhắc thanh toán cho " +
                tenantName +
                " sẽ được tích hợp backend sau."
            );

            return;
        }

        if (retryButton) {

            const confirmed = confirm(
                "Bạn có chắc chắn muốn thử thanh toán hóa đơn này bằng số dư ví?"
            );

            if (!confirmed) {
                return;
            }

            alert(
                "Chức năng thử thanh toán sẽ được tích hợp backend sau."
            );

        }

    });

    function updateEmptyState(tableBody, visibleCount) {

        const wrapper = tableBody.closest(".wallet-table-wrapper");
        const emptyMessage = wrapper.querySelector(".wallet-empty");

        emptyMessage.style.display =
            visibleCount === 0 ? "flex" : "none";

    }

    // BẬT / TẮT TRỪ TIỀN TỰ ĐỘNG
    function updateAutoDeductStatus() {

        const isEnabled = autoDeductEnabled.checked;

        toggleStatus.textContent = isEnabled
            ? "ĐANG BẬT"
            : "ĐANG TẮT";

    }

    autoDeductEnabled.addEventListener(
        "change",
        updateAutoDeductStatus
    );

    deductDay.addEventListener("change", function () {

        console.log(
            "Ngày trừ tiền được chọn:",
            deductDay.value
        );

    });

    runDeductButton.addEventListener("click", function () {

        const confirmed = confirm(
            "Bạn có chắc chắn muốn chạy trừ tiền tự động ngay bây giờ?"
        );

        if (!confirmed) {
            return;
        }

        alert(
            "Chức năng trừ tiền tự động sẽ được tích hợp backend sau."
        );

    });


    clearTopupSelection();

    switchTab("topup");

    updateEmptyState(topupTableBody, 0);
    updateEmptyState(historyTableBody, 0);
    updateEmptyState(debtTableBody, 0);
    updateEmptyState(autoDeductTableBody, 0);

    filterDebts();
    updateAutoDeductStatus();

});
