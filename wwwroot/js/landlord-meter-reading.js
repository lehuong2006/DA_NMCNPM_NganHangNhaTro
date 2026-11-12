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
        const digits = String(value).replace(/\D/g, "");

        return digits === "" ? null : Number(digits);
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

        return Math.round(value).toLocaleString("vi-VN");
    }

    function formatReading(value) {
        if (value === null || value === undefined) {
            return "—";
        }

        return Number(value).toLocaleString("vi-VN");
    }

    Object.values(servicePriceInputs).forEach(function (input) {

        input.addEventListener("input", function () {

            const digits = input.value.replace(/\D/g, "");

            input.value = digits === ""
                ? ""
                : Number(digits).toLocaleString("vi-VN");

            calculateInvoice();

        });

    });

    function getServicePrice(input) {
        return getNumericValue(input.value);
    }

    function calculateElectricityUsage() {

        const oldValue = getNumberValue(oldElectricReading.value);
        const newValue = getNumberValue(newElectricReading.value);

        if (oldValue === null || newValue === null) {
            electricityUsage.textContent = "—";
            electricityWarning.textContent = "";
            return null;
        }

        if (newValue < oldValue) {
            electricityUsage.textContent = "—";

            electricityWarning.textContent =
                "Chỉ số điện mới phải lớn hơn hoặc bằng chỉ số cũ.";

            return null;
        }

        const usage = newValue - oldValue;

        electricityUsage.textContent =
            formatReading(usage) + " kWh";

        electricityWarning.textContent = "";

        return usage;

    }

    function calculateInvoice() {

        const selectedRoom = roomSelect.selectedOptions[0];

        const hasRoom = roomSelect.value !== "";
        const roomFee = hasRoom
            ? getNumberValue(selectedRoom.dataset.rent)
            : null;

        const oldValue = getNumberValue(oldElectricReading.value);
        const newValue = getNumberValue(newElectricReading.value);

        const usage = calculateElectricityUsage();

        const people = getNumberValue(tenantCount.value);
        const vehicles = getNumberValue(vehicleCount.value);

        const electricityPrice = getServicePrice(
            servicePriceInputs.electricity
        );

        const waterPrice = getServicePrice(
            servicePriceInputs.water
        );

        const internetPrice = getServicePrice(
            servicePriceInputs.internet
        );

        const cleaningPrice = getServicePrice(
            servicePriceInputs.cleaning
        );

        const washingPrice = getServicePrice(
            servicePriceInputs.washing
        );

        const parkingPrice = getServicePrice(
            servicePriceInputs.parking
        );


        // Tiền điện
        const electricityFee =
            usage !== null && electricityPrice !== null
                ? usage * electricityPrice
                : null;


        // Tiền nước
        const waterFee =
            people !== null && waterPrice !== null
                ? people * waterPrice
                : null;


        // Internet
        const internetFee =
            people !== null && internetPrice !== null
                ? people * internetPrice
                : null;


        // Thang máy và vệ sinh
        const cleaningFee =
            people !== null && cleaningPrice !== null
                ? people * cleaningPrice
                : null;


        // Máy giặt
        const washingFee =
            people !== null && washingPrice !== null
                ? people * washingPrice
                : null;


        // Sạc xe điện
        const parkingFee =
            vehicles !== null && parkingPrice !== null
                ? vehicles * parkingPrice
                : null;


        // Hiển thị chi tiết
        previewElements.roomFee.textContent =
            roomFee === null ? "—" : formatMoney(roomFee);

        previewElements.electricityFee.textContent =
            electricityFee === null ? "—" : formatMoney(electricityFee);

        previewElements.waterFee.textContent =
            waterFee === null ? "—" : formatMoney(waterFee);

        previewElements.internetFee.textContent =
            internetFee === null ? "—" : formatMoney(internetFee);

        previewElements.cleaningFee.textContent =
            cleaningFee === null ? "—" : formatMoney(cleaningFee);

        previewElements.washingFee.textContent =
            washingFee === null ? "—" : formatMoney(washingFee);

        previewElements.parkingFee.textContent =
            parkingFee === null ? "—" : formatMoney(parkingFee);


        // Chỉ tính tổng khi các khoản phí cần thiết đã có dữ liệu
        const feeValues = [
            roomFee,
            electricityFee,
            waterFee,
            internetFee,
            cleaningFee,
            washingFee,
            parkingFee
        ];

        const hasCompleteData =
            hasRoom &&
            oldValue !== null &&
            newValue !== null &&
            usage !== null &&
            people !== null &&
            vehicles !== null &&
            feeValues.every(function (value) {
                return value !== null;
            });

        if (hasCompleteData) {

            const total = feeValues.reduce(function (sum, value) {
                return sum + value;
            }, 0);

            previewElements.total.textContent = formatMoney(total);

        } else {

            previewElements.total.textContent = "—";

        }

    }

    roomSelect.addEventListener("change", function () {

        const selectedRoom = roomSelect.selectedOptions[0];

        if (!roomSelect.value) {

            oldElectricReading.value = "";
            tenantCount.value = "";
            vehicleCount.value = "";

            calculateInvoice();
            return;

        }

        // Các giá trị này sẽ được backend truyền qua data-*.
        oldElectricReading.value =
            selectedRoom.dataset.oldReading || "";

        tenantCount.value =
            selectedRoom.dataset.tenantCount || "";

        vehicleCount.value =
            selectedRoom.dataset.vehicleCount || "";

        calculateInvoice();

    });

    [
        newElectricReading,
        tenantCount,
        vehicleCount,
        oldElectricReading
    ].forEach(function (input) {

        input.addEventListener("input", calculateInvoice);

    });

    billingPeriod.addEventListener("change", function () {

        calculateInvoice();

    });

    document.querySelector(".save-price-button")
        .addEventListener("click", function () {

            alert("Chức năng lưu đơn giá sẽ được tích hợp backend sau.");

        });

    document.querySelector(".save-reading-button")
        .addEventListener("click", function () {

            if (!meterReadingForm.reportValidity()) {
                return;
            }

            if (!roomSelect.value) {
                alert("Vui lòng chọn phòng.");
                return;
            }

            const oldValue = getNumberValue(oldElectricReading.value);
            const newValue = getNumberValue(newElectricReading.value);

            if (oldValue === null) {
                alert("Chưa có chỉ số điện cũ của phòng.");
                return;
            }

            if (newValue < oldValue) {
                alert("Chỉ số điện mới không được nhỏ hơn chỉ số cũ.");
                return;
            }

            alert("Giao diện đã kiểm tra dữ liệu. Chức năng lưu database sẽ được tích hợp sau.");

        });

    calculateInvoice();

});
