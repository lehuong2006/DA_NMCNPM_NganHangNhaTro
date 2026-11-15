document.addEventListener("DOMContentLoaded", function () {

    const meterReadingForm = document.getElementById("meterReadingForm");

    const roomSelect = document.getElementById("roomSelect");
    const billingPeriod = document.getElementById("billingPeriod");

    const oldElectricReading = document.getElementById("oldElectricReading");
    const newElectricReading = document.getElementById("newElectricReading");

    const tenantCount = document.getElementById("tenantCount");
    const vehicleCount = document.getElementById("vehicleCount");

    const electricityUsage = document.getElementById("electricityUsage");
    const electricityWarning = document.getElementById("electricityWarning");

    const servicePriceInputs = {
        electricity: document.getElementById("electricPrice"),
        water: document.getElementById("waterPrice"),
        internet: document.getElementById("internetPrice"),
        cleaning: document.getElementById("cleaningPrice"),
        washing: document.getElementById("washingPrice"),
        parking: document.getElementById("parkingPrice")
    };

    const previewElements = {
        roomFee: document.getElementById("previewRoomFee"),
        electricityFee: document.getElementById("previewElectricityFee"),
        waterFee: document.getElementById("previewWaterFee"),
        internetFee: document.getElementById("previewInternetFee"),
        cleaningFee: document.getElementById("previewCleaningFee"),
        washingFee: document.getElementById("previewWashingFee"),
        parkingFee: document.getElementById("previewParkingFee"),
        total: document.getElementById("previewTotal")
    };

    function getNumericValue(value) {
        if (!value) return 0;
        const digits = String(value).replace(/\D/g, "");
        return digits === "" ? 0 : Number(digits);
    }

    function getNumberValue(value) {
        if (value === "" || value === null || value === undefined) {
            return null;
        }
        const number = Number(value);
        return Number.isFinite(number) ? number : null;
    }

    function formatMoney(value) {
        if (value === null || value === undefined) {
            return "—";
        }
        return Math.round(value).toLocaleString("vi-VN") + " VNĐ";
    }

    function formatReading(value) {
        if (value === null || value === undefined) {
            return "—";
        }
        return Number(value).toLocaleString("vi-VN");
    }

    Object.values(servicePriceInputs).forEach(function (input) {
        if (!input) return;
        input.addEventListener("input", function () {
            const digits = input.value.replace(/\D/g, "");
            input.value = digits === "" ? "" : Number(digits).toLocaleString("vi-VN");
            calculateInvoice();
        });
    });

    function getServicePrice(input) {
        if (!input) return 0;
        return getNumericValue(input.value);
    }

    function calculateElectricityUsage() {
        const oldValue = getNumberValue(oldElectricReading.value) ?? 0;
        const newValue = getNumberValue(newElectricReading.value);

        if (newValue === null) {
            electricityUsage.textContent = "—";
            electricityWarning.textContent = "";
            return null;
        }

        if (newValue < oldValue) {
            electricityUsage.textContent = "—";
            electricityWarning.textContent = "Chỉ số điện mới phải lớn hơn hoặc bằng chỉ số cũ.";
            return null;
        }

        const usage = newValue - oldValue;
        electricityUsage.textContent = formatReading(usage) + " kWh";
        electricityWarning.textContent = "";
        return usage;
    }

    function calculateInvoice() {
        const selectedRoom = roomSelect.selectedOptions[0];
        const hasRoom = roomSelect.value !== "";
        const roomFee = (hasRoom && selectedRoom)
            ? (Number(selectedRoom.dataset.price) || 0)
            : 0;

        const oldValue = getNumberValue(oldElectricReading.value) ?? 0;
        const newValue = getNumberValue(newElectricReading.value);
        const usage = calculateElectricityUsage() ?? 0;

        const people = getNumberValue(tenantCount.value) ?? 1;
        const vehicles = getNumberValue(vehicleCount.value) ?? 0;

        const electricityPrice = getServicePrice(servicePriceInputs.electricity) || 3500;
        const waterPrice = getServicePrice(servicePriceInputs.water) || 50000;
        const internetPrice = getServicePrice(servicePriceInputs.internet) || 50000;
        const cleaningPrice = getServicePrice(servicePriceInputs.cleaning) || 100000;
        const washingPrice = getServicePrice(servicePriceInputs.washing) || 50000;
        const parkingPrice = getServicePrice(servicePriceInputs.parking) || 100000;

        const electricityFee = usage * electricityPrice;
        const waterFee = people * waterPrice;
        const internetFee = people * internetPrice;
        const cleaningFee = people * cleaningPrice;
        const washingFee = people * washingPrice;
        const parkingFee = vehicles * parkingPrice;

        previewElements.roomFee.textContent = formatMoney(roomFee);
        previewElements.electricityFee.textContent = formatMoney(electricityFee);
        previewElements.waterFee.textContent = formatMoney(waterFee);
        previewElements.internetFee.textContent = formatMoney(internetFee);
        previewElements.cleaningFee.textContent = formatMoney(cleaningFee);
        previewElements.washingFee.textContent = formatMoney(washingFee);
        previewElements.parkingFee.textContent = formatMoney(parkingFee);

        const total = roomFee + electricityFee + waterFee + internetFee + cleaningFee + washingFee + parkingFee;
        previewElements.total.textContent = formatMoney(total);
    }

    [oldElectricReading, newElectricReading, tenantCount, vehicleCount].forEach(function (input) {
        if (!input) return;
        input.addEventListener("input", calculateInvoice);
    });

    roomSelect.addEventListener("change", calculateInvoice);
    billingPeriod.addEventListener("change", calculateInvoice);

    // Lưu đơn giá dịch vụ
    const savePriceBtn = document.querySelector(".save-price-button");
    if (savePriceBtn) {
        savePriceBtn.addEventListener("click", async function () {
            const prices = [
                { serviceCode: "ELECTRIC", unitPrice: getServicePrice(servicePriceInputs.electricity) },
                { serviceCode: "WATER", unitPrice: getServicePrice(servicePriceInputs.water) },
                { serviceCode: "INTERNET", unitPrice: getServicePrice(servicePriceInputs.internet) },
                { serviceCode: "CLEANING", unitPrice: getServicePrice(servicePriceInputs.cleaning) },
                { serviceCode: "WASHING", unitPrice: getServicePrice(servicePriceInputs.washing) },
                { serviceCode: "PARKING", unitPrice: getServicePrice(servicePriceInputs.parking) }
            ];

            try {
                const res = await fetch("/Landlord/SaveServicePrices", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(prices)
                });
                const data = await res.json();
                alert(data.message || "Đã lưu đơn giá thành công!");
            } catch (err) {
                console.error(err);
                alert("Lỗi khi lưu đơn giá dịch vụ.");
            }
        });
    }

    // Lưu chỉ số và tạo hóa đơn
    const saveReadingBtn = document.querySelector(".save-reading-button");
    if (saveReadingBtn) {
        saveReadingBtn.addEventListener("click", async function () {
            if (!roomSelect.value) {
                alert("Vui lòng chọn phòng để ghi chỉ số điện nước.");
                roomSelect.focus();
                return;
            }

            const oldValue = getNumberValue(oldElectricReading.value) ?? 0;
            const newValue = getNumberValue(newElectricReading.value);

            if (newValue === null) {
                alert("Vui lòng nhập chỉ số điện mới.");
                newElectricReading.focus();
                return;
            }

            if (newValue < oldValue) {
                alert("Chỉ số điện mới không được nhỏ hơn chỉ số cũ.");
                newElectricReading.focus();
                return;
            }

            const payload = {
                roomId: Number(roomSelect.value),
                monthYear: billingPeriod.value,
                elecOld: oldValue,
                elecNew: newValue,
                tenantCount: getNumberValue(tenantCount.value) ?? 1,
                vehicleCount: getNumberValue(vehicleCount.value) ?? 0,
                electricPrice: getServicePrice(servicePriceInputs.electricity) || 3500,
                waterPrice: getServicePrice(servicePriceInputs.water) || 50000,
                internetPrice: getServicePrice(servicePriceInputs.internet) || 50000,
                cleaningPrice: getServicePrice(servicePriceInputs.cleaning) || 100000,
                washingPrice: getServicePrice(servicePriceInputs.washing) || 50000,
                parkingPrice: getServicePrice(servicePriceInputs.parking) || 100000
            };

            saveReadingBtn.disabled = true;
            saveReadingBtn.textContent = "Đang lưu...";

            try {
                const res = await fetch("/Landlord/SaveMeterReading", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(payload)
                });
                const data = await res.json();
                if (data.success) {
                    alert(data.message || "Lưu chỉ số và tạo hóa đơn thành công!");
                    window.location.href = "/Landlord/Invoices";
                } else {
                    alert(data.message || "Lưu chỉ số thất bại.");
                }
            } catch (err) {
                console.error(err);
                alert("Đã xảy ra lỗi khi lưu chỉ số điện nước.");
            } finally {
                saveReadingBtn.disabled = false;
                saveReadingBtn.textContent = "Lưu thay đổi";
            }
        });
    }

    calculateInvoice();
});
