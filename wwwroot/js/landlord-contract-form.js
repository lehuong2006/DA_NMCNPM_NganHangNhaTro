document.addEventListener("DOMContentLoaded", function () {

    const moneyInputs = [
        document.getElementById("rentalPrice"),
        document.getElementById("depositAmount"),
        document.getElementById("electricPrice"),
        document.getElementById("waterPrice"),
        document.getElementById("washingPrice"),
        document.getElementById("cleaningPrice"),
        document.getElementById("internetPrice"),
        document.getElementById("parkingPrice")
    ];

    const depositInput = document.getElementById("depositAmount");
    const depositDisplay = document.getElementById("depositDisplay");

    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");

    const viewTermsButton = document.getElementById("viewTermsButton");

    function formatMoney(value) {
        const digits = value.replace(/\D/g, "");

        if (digits === "") {
            return "";
        }

        return Number(digits).toLocaleString("vi-VN");
    }

    moneyInputs.forEach(function (input) {

        if (!input) return;

        input.addEventListener("input", function () {

            input.value = formatMoney(input.value);

            if (input === depositInput) {
                updateDeposit();
            }

        });

    });

    function updateDeposit() {

        const depositValue = depositInput.value.replace(/\D/g, "");
        const amount = Number(depositValue || 0);

        depositDisplay.textContent =
            amount.toLocaleString("vi-VN") + " VNĐ";

    }

    startDate.addEventListener("change", function () {

        endDate.min = startDate.value;

        if (endDate.value && endDate.value < startDate.value) {
            endDate.value = "";
        }

    });

    endDate.addEventListener("change", function () {

        if (startDate.value && endDate.value < startDate.value) {
            endDate.value = "";
        }

    });

    viewTermsButton.addEventListener("click", function () {

        alert("Nội dung điều khoản hợp đồng sẽ được bổ sung sau.");

    });

    updateDeposit();

});
