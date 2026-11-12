document.addEventListener("DOMContentLoaded", function () {

    const searchInput = document.getElementById("accountSearch");
    const roleFilters = document.querySelectorAll(".role-filter");
    const tableBody = document.getElementById("accountTableBody");
    const emptyMessage = document.querySelector(".account-empty");

    let selectedRole = "";

    function filterAccounts() {

        const keyword = searchInput.value.trim().toLowerCase();

        const rows = tableBody.querySelectorAll("tr");

        let visibleCount = 0;

        rows.forEach(function (row) {

            const role = row.dataset.role || "";

            const searchContent = (
                row.dataset.search || row.textContent
            ).toLowerCase();

            const matchesRole =
                !selectedRole || role === selectedRole;

            const matchesKeyword =
                !keyword || searchContent.includes(keyword);

            const isVisible = matchesRole && matchesKeyword;

            row.hidden = !isVisible;

            if (isVisible) {
                visibleCount++;
            }

        });

        emptyMessage.hidden = visibleCount > 0;

    }

    roleFilters.forEach(function (button) {

        button.addEventListener("click", function () {

            roleFilters.forEach(function (item) {
                item.classList.remove("active");
            });

            button.classList.add("active");

            selectedRole = button.dataset.role || "";

            filterAccounts();

        });

    });

    searchInput.addEventListener("input", filterAccounts);

    filterAccounts();

});
