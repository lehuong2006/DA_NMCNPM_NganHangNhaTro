document.addEventListener("DOMContentLoaded", function () {

    const tableBody = document.getElementById("transactionTableBody");
    const emptyMessage = document.querySelector(".history-empty");

    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");

    const typeFilter = document.getElementById("transactionTypeFilter");
    const statusFilter = document.getElementById("transactionStatusFilter");
    const searchInput = document.getElementById("transactionSearch");

    function validateDateRange() {

        if (startDate.value && endDate.value) {

            if (startDate.value > endDate.value) {
                endDate.setCustomValidity(
                    "Ngày kết thúc không được trước ngày bắt đầu."
                );
                return false;
            }

        }

        endDate.setCustomValidity("");
        return true;

    }

    function filterTransactions() {

        if (!validateDateRange()) {
            endDate.reportValidity();
            return;
        }

        const selectedType = typeFilter.value;
        const selectedStatus = statusFilter.value;
        const keyword = searchInput.value.trim().toLowerCase();

        const rows = tableBody.querySelectorAll("tr");

        let visibleCount = 0;

        rows.forEach(function (row) {

            const date = row.dataset.date || "";
            const type = row.dataset.type || "";
            const status = row.dataset.status || "";

            const searchContent = (
                row.dataset.search || row.textContent
            ).toLowerCase();

            const matchesStartDate =
                !startDate.value || date >= startDate.value;

            const matchesEndDate =
                !endDate.value || date <= endDate.value;

            const matchesType =
                !selectedType || type === selectedType;

            const matchesStatus =
                !selectedStatus || status === selectedStatus;

            const matchesKeyword =
                !keyword || searchContent.includes(keyword);

            const isVisible =
                matchesStartDate &&
                matchesEndDate &&
                matchesType &&
                matchesStatus &&
                matchesKeyword;

            row.hidden = !isVisible;

            if (isVisible) {
                visibleCount++;
            }

        });

        emptyMessage.hidden = visibleCount > 0;

    }

    startDate.addEventListener("change", filterTransactions);
    endDate.addEventListener("change", filterTransactions);

    typeFilter.addEventListener("change", filterTransactions);
    statusFilter.addEventListener("change", filterTransactions);

    searchInput.addEventListener("input", filterTransactions);

    filterTransactions();

});
