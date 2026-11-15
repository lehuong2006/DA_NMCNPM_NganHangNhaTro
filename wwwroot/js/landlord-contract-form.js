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

    const roomSelect = document.getElementById("roomSelect");
    const roomArea = document.getElementById("roomArea");
    const rentalPriceInput = document.getElementById("rentalPrice");

    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");

    const tenantName = document.getElementById("tenantName");
    const tenantPhone = document.getElementById("tenantPhone");
    const tenantIdentity = document.getElementById("tenantIdentity");
    const tenantAddress = document.getElementById("tenantAddress");

    const viewTermsButton = document.getElementById("viewTermsButton");
    const saveButton = document.querySelector(".save-button");

    function formatMoney(value) {
        const digits = String(value).replace(/\D/g, "");

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
        if (!depositInput || !depositDisplay) return;
        const depositValue = depositInput.value.replace(/\D/g, "");
        const amount = Number(depositValue || 0);

        depositDisplay.textContent =
            amount.toLocaleString("vi-VN") + " VNĐ";
    }

    if (roomSelect) {
        function handleRoomChange() {
            const selectedOption = roomSelect.options[roomSelect.selectedIndex];
            if (selectedOption && selectedOption.value) {
                const price = selectedOption.dataset.price;
                const area = selectedOption.dataset.area || "25";
                if (roomArea) roomArea.value = area + " m²";
                if (rentalPriceInput && price) {
                    rentalPriceInput.value = formatMoney(price);
                }
                if (depositInput && price && !depositInput.value) {
                    depositInput.value = formatMoney(price);
                    updateDeposit();
                }
            } else {
                if (roomArea) roomArea.value = "";
            }
        }

        roomSelect.addEventListener("change", handleRoomChange);
        handleRoomChange();
    }

    if (startDate) {
        // Gán mặc định ngày hôm nay nếu chưa có
        if (!startDate.value) {
            startDate.value = new Date().toISOString().split("T")[0];
        }

        startDate.addEventListener("change", function () {
            endDate.min = startDate.value;
            if (endDate.value && endDate.value < startDate.value) {
                endDate.value = "";
            }
        });
    }

    if (endDate) {
        endDate.addEventListener("change", function () {
            if (startDate.value && endDate.value < startDate.value) {
                endDate.value = "";
            }
        });
    }

    if (viewTermsButton) {
        viewTermsButton.addEventListener("click", function () {
            alert("Điều khoản hợp đồng:\n1. Bên thuê thanh toán tiền phòng đúng hạn vào đầu mỗi kỳ.\n2. Giữ gìn an ninh trật tự, vệ sinh chung.\n3. Tiền đặt cọc sẽ được hoàn trả khi kết thúc hợp đồng theo quy định.");
        });
    }

    if (saveButton) {
        saveButton.addEventListener("click", async function () {
            if (!roomSelect.value) {
                alert("Vui lòng chọn phòng để lập hợp đồng.");
                roomSelect.focus();
                return;
            }

            if (!tenantName.value.trim()) {
                alert("Vui lòng nhập họ và tên người thuê.");
                tenantName.focus();
                return;
            }

            if (!tenantPhone.value.trim()) {
                alert("Vui lòng nhập số điện thoại người thuê.");
                tenantPhone.focus();
                return;
            }

            const rentalPriceVal = Number((rentalPriceInput.value || "").replace(/\D/g, "")) || 0;
            const depositVal = Number((depositInput.value || "").replace(/\D/g, "")) || 0;

            const payload = {
                roomId: Number(roomSelect.value),
                tenantName: tenantName.value.trim(),
                tenantPhone: tenantPhone.value.trim(),
                tenantIdentity: tenantIdentity ? tenantIdentity.value.trim() : "",
                tenantAddress: tenantAddress ? tenantAddress.value.trim() : "",
                startDate: startDate.value,
                endDate: endDate.value,
                rentalPrice: rentalPriceVal,
                depositAmount: depositVal
            };

            saveButton.disabled = true;
            saveButton.textContent = "Đang lưu...";

            try {
                const response = await fetch("/Landlord/SaveContract", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(payload)
                });

                const result = await response.json();
                if (result.success) {
                    alert(result.message || "Lập hợp đồng thành công!");
                    window.location.href = "/Landlord/Tenants";
                } else {
                    alert(result.message || "Lập hợp đồng thất bại.");
                }
            } catch (err) {
                console.error(err);
                alert("Đã xảy ra lỗi khi lưu hợp đồng.");
            } finally {
                saveButton.disabled = false;
                saveButton.textContent = "Lưu";
            }
        });
    }

    updateDeposit();
});
