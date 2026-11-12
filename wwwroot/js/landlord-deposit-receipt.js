document.addEventListener("DOMContentLoaded", function () {

    const depositForm = document.getElementById("depositForm");

    const roomSelect = document.getElementById("roomSelect");
    const roomPrice = document.getElementById("roomPrice");
    const roomArea = document.getElementById("roomArea");
    const roomStatus = document.querySelector(".room-status");

    const existingTenantSection = document.getElementById("existingTenantSection");
    const newTenantSection = document.getElementById("newTenantSection");
    const tenantSelect = document.getElementById("tenantSelect");
    const tenantModeButtons = document.querySelectorAll(".tenant-mode-button");

    const depositAmount = document.getElementById("depositAmount");
    const depositDate = document.getElementById("depositDate");
    const moveInDate = document.getElementById("moveInDate");
    const holdUntilDate = document.getElementById("holdUntilDate");

    const paymentMethods = document.querySelectorAll(
        'input[name="paymentMethod"]'
    );

    const newTenantName = document.getElementById("newTenantName");
    const newTenantIdentity = document.getElementById("newTenantIdentity");
    const newTenantPhone = document.getElementById("newTenantPhone");
    const newTenantAddress = document.getElementById("newTenantAddress");

    const previewTenantName = document.getElementById("previewTenantName");
    const previewTenantIdentity = document.getElementById("previewTenantIdentity");
    const previewTenantPhone = document.getElementById("previewTenantPhone");

    const previewRoom = document.getElementById("previewRoom");
    const previewRoomPrice = document.getElementById("previewRoomPrice");

    const previewDepositAmount = document.getElementById("previewDepositAmount");
    const previewPaymentMethod = document.getElementById("previewPaymentMethod");

    const previewDepositDate = document.getElementById("previewDepositDate");
    const previewMoveInDate = document.getElementById("previewMoveInDate");
    const previewHoldDate = document.getElementById("previewHoldDate");


    function formatMoney(value) {
        const digits = value.replace(/\D/g, "");

        if (digits === "") {
            return "";
        }

        return Number(digits).toLocaleString("vi-VN");
    }

    function getNumericValue(value) {
        return Number(value.replace(/\D/g, "") || 0);
    }

    function formatMoneyDisplay(value) {
        return getNumericValue(value).toLocaleString("vi-VN") + " VNĐ";
    }

    function formatDate(value) {
        if (!value) {
            return "—";
        }

        const parts = value.split("-");

        if (parts.length !== 3) {
            return "—";
        }

        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    let tenantMode = "existing";

    function setTenantMode(mode) {
        tenantMode = mode;

        tenantModeButtons.forEach(function (button) {
            button.classList.toggle(
                "active",
                button.dataset.mode === mode
            );
        });

        existingTenantSection.hidden = mode !== "existing";
        newTenantSection.hidden = mode !== "new";

        newTenantName.required = mode === "new";
        newTenantIdentity.required = mode === "new";
        newTenantPhone.required = mode === "new";
        newTenantAddress.required = mode === "new";

        tenantSelect.required = mode === "existing";

        updateTenantPreview();
    }

    tenantModeButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            setTenantMode(button.dataset.mode);
        });
    });

    function updateTenantPreview() {

        if (tenantMode === "new") {
            previewTenantName.textContent =
                newTenantName.value.trim() || "—";

            previewTenantIdentity.textContent =
                newTenantIdentity.value.trim() || "—";

            previewTenantPhone.textContent =
                newTenantPhone.value.trim() || "—";

            return;
        }

        const selectedOption = tenantSelect.selectedOptions[0];

        if (!selectedOption || !tenantSelect.value) {
            previewTenantName.textContent = "—";
            previewTenantIdentity.textContent = "—";
            previewTenantPhone.textContent = "—";
            return;
        }

        previewTenantName.textContent =
            selectedOption.dataset.name || selectedOption.textContent;

        previewTenantIdentity.textContent =
            selectedOption.dataset.identity || "—";

        previewTenantPhone.textContent =
            selectedOption.dataset.phone || "—";
    }

    tenantSelect.addEventListener("change", updateTenantPreview);

    [
        newTenantName,
        newTenantIdentity,
        newTenantPhone
    ].forEach(function (input) {
        input.addEventListener("input", updateTenantPreview);
    });

    function updateRoomPreview() {

        const selectedOption = roomSelect.selectedOptions[0];

        if (!selectedOption || !roomSelect.value) {
            roomStatus.textContent = "Chưa chọn phòng";
            roomPrice.textContent = "—";
            roomArea.textContent = "—";

            previewRoom.textContent = "—";
            previewRoomPrice.textContent = "—";

            return;
        }

        const selectedRoomName =
            selectedOption.dataset.name || selectedOption.textContent;

        const selectedPrice =
            selectedOption.dataset.price || "";

        const selectedArea =
            selectedOption.dataset.area || "";

        roomStatus.textContent =
            selectedOption.dataset.status || "Trống";

        roomPrice.textContent =
            selectedPrice ? formatMoneyDisplay(selectedPrice) + "/tháng" : "—";

        roomArea.textContent =
            selectedArea ? selectedArea + " m²" : "—";

        previewRoom.textContent = selectedRoomName;

        previewRoomPrice.textContent =
            selectedPrice ? formatMoneyDisplay(selectedPrice) : "—";
    }

    roomSelect.addEventListener("change", updateRoomPreview);

    depositAmount.addEventListener("input", function () {

        depositAmount.value = formatMoney(depositAmount.value);

        updateDepositPreview();

    });

    function updateDepositPreview() {

        previewDepositAmount.textContent =
            formatMoneyDisplay(depositAmount.value);

    }

    function updatePaymentMethod() {

        paymentMethods.forEach(function (radio) {

            const label = radio.closest(".payment-method");

            label.classList.toggle("active", radio.checked);

            if (radio.checked) {
                previewPaymentMethod.textContent =
                    radio.value === "cash" ? "Tiền mặt" : "Chuyển khoản";
            }

        });

    }

    paymentMethods.forEach(function (radio) {
        radio.addEventListener("change", updatePaymentMethod);
    });

    function updateDatePreview() {
        previewDepositDate.textContent = formatDate(depositDate.value);
        previewMoveInDate.textContent = formatDate(moveInDate.value);
        previewHoldDate.textContent = formatDate(holdUntilDate.value);
    }

    [depositDate, moveInDate, holdUntilDate].forEach(function (input) {
        input.addEventListener("change", updateDatePreview);
    });

    moveInDate.addEventListener("change", function () {

        holdUntilDate.min = depositDate.value || "";

        if (
            holdUntilDate.value &&
            holdUntilDate.value < depositDate.value
        ) {
            holdUntilDate.value = "";
        }

    });

    depositDate.addEventListener("change", function () {

        moveInDate.min = depositDate.value;
        holdUntilDate.min = depositDate.value;

        if (
            moveInDate.value &&
            moveInDate.value < depositDate.value
        ) {
            moveInDate.value = "";
        }

        if (
            holdUntilDate.value &&
            holdUntilDate.value < depositDate.value
        ) {
            holdUntilDate.value = "";
        }

        updateDatePreview();

    });

    setTenantMode("existing");

    updateRoomPreview();
    updateTenantPreview();
    updateDepositPreview();
    updatePaymentMethod();
    updateDatePreview();


    // Chặn submit mặc định vì chưa có backend
    depositForm.addEventListener("submit", function (event) {
        event.preventDefault();
    });

});
