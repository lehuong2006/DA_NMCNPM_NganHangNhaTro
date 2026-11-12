document.addEventListener("DOMContentLoaded", function () {

    const roleSearch = document.getElementById("roleSearch");
    const roleTableBody = document.getElementById("roleTableBody");
    const roleEmptyMessage = document.querySelector(".role-list-empty");

    const allRolesButton = document.getElementById("allRolesButton");

    const selectedRoleName = document.getElementById("selectedRoleName");

    const cancelButton = document.getElementById(
        "cancelPermissionButton"
    );

    const saveButton = document.getElementById(
        "savePermissionButton"
    );

    const permissionCheckboxes = document.querySelectorAll(
        ".permission-table input[type='checkbox']"
    );

    const initialPermissions = Array.from(
        permissionCheckboxes
    ).map(function (checkbox) {
        return checkbox.checked;
    });

    function filterRoles() {

        const keyword = roleSearch.value.trim().toLowerCase();

        const rows = roleTableBody.querySelectorAll("tr");

        let visibleCount = 0;

        rows.forEach(function (row) {

            const searchContent = (
                row.dataset.search || row.textContent
            ).toLowerCase();

            const isVisible = searchContent.includes(keyword);

            row.hidden = !isVisible;

            if (isVisible) {
                visibleCount++;
            }

        });

        roleEmptyMessage.hidden = visibleCount > 0;

    }


    roleSearch.addEventListener("input", filterRoles);


    allRolesButton.addEventListener("click", function () {

        allRolesButton.classList.add("active");

        roleSearch.value = "";

        filterRoles();

    });

    cancelButton.addEventListener("click", function () {

        permissionCheckboxes.forEach(function (checkbox, index) {

            checkbox.checked = initialPermissions[index];

        });

    });

    saveButton.addEventListener("click", function () {

        const confirmed = confirm(
            "Bạn có chắc chắn muốn lưu các thay đổi phân quyền?"
        );

        if (!confirmed) {
            return;
        }

        alert(
            "Đã kiểm tra giao diện. " +
            "Chức năng lưu phân quyền sẽ được tích hợp backend sau."
        );

    });

    filterRoles();

});
