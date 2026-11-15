document.addEventListener("DOMContentLoaded", function () {

    const amountOptions = document.querySelectorAll(".amount-option");
    const topupAmount = document.getElementById("topupAmount");
    const topupContent = document.getElementById("topupContent");
    const topupSubmitButton = document.getElementById("topupSubmitButton");
    const bankQrImage = document.getElementById("bankQrImage");

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

    function updateQrCode() {
        if (!bankQrImage) return;
        const amount = getAmountValue();
        const content = topupContent ? topupContent.value.trim() : "";
        const qrUrl = `https://img.vietqr.io/image/MB-0825611111-compact2.png?amount=${amount}&addInfo=${encodeURIComponent(content || 'NAP TIEN VI')}&accountName=NGUYEN%20VAN%20QUAN`;
        bankQrImage.src = qrUrl;
    }

    amountOptions.forEach(function (button) {

        button.addEventListener("click", function () {

            amountOptions.forEach(function (item) {
                item.classList.remove("active");
            });

            button.classList.add("active");

            const amount = Number(button.dataset.amount);
            topupAmount.value = formatMoney(amount);
            updateQrCode();
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

        updateQrCode();
    });

    if (topupContent) {
        topupContent.addEventListener("input", updateQrCode);
    }

    // =============================================
    // GỬI YÊU CẦU NẠP TIỀN → GỌI API BACKEND
    // =============================================
    topupSubmitButton.addEventListener("click", async function () {

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

        topupSubmitButton.disabled = true;
        topupSubmitButton.textContent = "Đang gửi...";

        try {
            const response = await fetch("/Tenant/SubmitTopup", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ amount: amount, content: content })
            });

            const result = await response.json();

            if (result.success) {
                alert("✅ " + result.message);
                // Reset form
                topupAmount.value = "";
                topupContent.value = "";
                amountOptions.forEach(function (btn) {
                    btn.classList.remove("active");
                });
            } else {
                alert("❌ " + result.message);
            }

        } catch (err) {
            alert("❌ Không thể kết nối đến máy chủ. Vui lòng thử lại.");
        } finally {
            topupSubmitButton.disabled = false;
            topupSubmitButton.textContent = "Gửi yêu cầu";
        }

    });

    if (transactionTableBody && transactionEmpty) {

        const hasTransactions =
            transactionTableBody.querySelector("tr") !== null;

        transactionEmpty.hidden = hasTransactions;

    }

});
