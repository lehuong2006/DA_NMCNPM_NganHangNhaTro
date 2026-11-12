document.addEventListener("DOMContentLoaded", function () {

    const amountOptions = document.querySelectorAll(".amount-option");
    const topupAmount = document.getElementById("topupAmount");
    const topupContent = document.getElementById("topupContent");
    const topupSubmitButton = document.getElementById("topupSubmitButton");

    const transactionTableBody = document.getElementById(
        "tenantTransactionTableBody"
    );

    const transactionEmpty = document.querySelector(
        ".transaction-empty"
    );

    function formatMoney(value) {

        const amount = Number(value || 0);

        return amount.toLocaleString("vi-VN");

    }

    function getAmountValue() {

        return Number(
            topupAmount.value.replace(/\D/g, "")
        );

    }

    amountOptions.forEach(function (button) {

        button.addEventListener("click", function () {

            amountOptions.forEach(function (item) {
                item.classList.remove("active");
            });

            button.classList.add("active");

            const amount = Number(button.dataset.amount);

            topupAmount.value = formatMoney(amount);

        });

    });

    topupAmount.addEventListener("input", function () {

        const amount = getAmountValue();

        topupAmount.value = amount > 0
            ? formatMoney(amount)
            : "";

        amountOptions.forEach(function (button) {

            const isSelected =
                Number(button.dataset.amount) === amount;

            button.classList.toggle("active", isSelected);

        });

    });

    topupSubmitButton.addEventListener("click", function () {

        const amount = getAmountValue();
        const content = topupContent.value.trim();

        if (!amount || amount <= 0) {
            alert("Vui lòng nhập số tiền muốn nạp.");
            topupAmount.focus();
            return;
        }

        if (!content) {
            alert("Vui lòng nhập nội dung chuyển khoản.");
            topupContent.focus();
            return;
        }

        alert(
            "Thông tin đã được kiểm tra. " +
            "Chức năng gửi yêu cầu nạp tiền sẽ được tích hợp backend sau."
        );

    });

    if (transactionTableBody && transactionEmpty) {

        const hasTransactions =
            transactionTableBody.querySelector("tr") !== null;

        transactionEmpty.hidden = hasTransactions;

    }

});
