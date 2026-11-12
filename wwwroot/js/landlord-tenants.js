document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("tenantSearch");
    const roomFilter = document.getElementById("roomFilter");
    const statusFilter = document.getElementById("statusFilter");
    const filterButton = document.getElementById("filterButton");

    const tableBody = document.getElementById("tenantTableBody");
    const emptyMessage = document.querySelector(".tenant-empty");

    function filterTenants() {
        const searchValue = searchInput.value.trim().toLowerCase();
        const selectedRoom = roomFilter.value;
        const selectedStatus = statusFilter.value;

        const rows = tableBody.querySelectorAll("tr");
        let visibleCount = 0;

        rows.forEach(function (row) {
            const rowText = row.textContent.toLowerCase();
            const room = row.dataset.room || "";
            const status = row.dataset.status || "";

            const matchesSearch = rowText.includes(searchValue);
            const matchesRoom =
                selectedRoom === "" || room === selectedRoom;
            const matchesStatus =
                selectedStatus === "" || status === selectedStatus;

            const isVisible =
                matchesSearch && matchesRoom && matchesStatus;

            row.style.display = isVisible ? "" : "none";

            if (isVisible) {
                visibleCount++;
            }
        });

        emptyMessage.style.display =
            rows.length === 0 || visibleCount === 0 ? "flex" : "none";
    }

    searchInput.addEventListener("input", filterTenants);
    roomFilter.addEventListener("change", filterTenants);
    statusFilter.addEventListener("change", filterTenants);

    filterButton.addEventListener("click", filterTenants);

    // Cập nhật trạng thái hiển thị ban đầu
    filterTenants();
});
