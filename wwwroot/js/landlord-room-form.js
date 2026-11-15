document.addEventListener("DOMContentLoaded", function () {
    const roomIdInput = document.getElementById("roomId");
    const roomCodeInput = document.getElementById("roomCode");
    const roomFloorInput = document.getElementById("roomFloor");
    const roomPriceInput = document.getElementById("roomPrice");
    const roomStatusInput = document.getElementById("roomStatus");
    const roomAreaInput = document.getElementById("roomArea");
    const maxTenantsInput = document.getElementById("maxTenants");
    const descriptionInput = document.getElementById("roomDescription");
    const descriptionCount = document.getElementById("descriptionCount");

    const editingBadge = document.getElementById("editingBadge");
    const roomSearchInput = document.getElementById("roomSearch");
    const roomSelectionList = document.getElementById("roomSelectionList");
    const addAnotherRoomBtn = document.getElementById("addAnotherRoom");
    const deleteRoomBtn = document.getElementById("deleteRoomButton");
    const saveButton = document.querySelector(".save-button");

    const imageInput = document.getElementById("roomImages");
    const imageList = document.getElementById("imageList");

    let selectedImages = [];

    // =============================================
    // 1. CHỌN PHÒNG ĐỂ SỬA TỪ DANH SÁCH BÊN PHẢI
    // =============================================
    if (roomSelectionList) {
        roomSelectionList.addEventListener("click", function (e) {
            const item = e.target.closest(".room-selection-item");
            if (!item) return;

            // Xóa active cũ
            roomSelectionList.querySelectorAll(".room-selection-item").forEach(function (el) {
                el.classList.remove("selected");
            });
            item.classList.add("selected");

            // Đổ dữ liệu vào form
            const id = item.dataset.id;
            const code = item.dataset.code;
            const price = item.dataset.price;
            const floor = item.dataset.floor;
            const maxTenants = item.dataset.max;
            const status = item.dataset.status;

            if (roomIdInput) roomIdInput.value = id;
            if (roomCodeInput) roomCodeInput.value = code;
            if (roomPriceInput) roomPriceInput.value = price;
            if (roomFloorInput) roomFloorInput.value = floor;
            if (roomStatusInput) roomStatusInput.value = status;
            if (maxTenantsInput) maxTenantsInput.value = maxTenants;

            if (editingBadge) {
                editingBadge.textContent = "Đang sửa: " + code;
            }

            if (deleteRoomBtn) {
                deleteRoomBtn.disabled = false;
            }
        });
    }

    // =============================================
    // 2. TÌM KIẾM PHÒNG BÊN DANH SÁCH PHẢI
    // =============================================
    if (roomSearchInput && roomSelectionList) {
        roomSearchInput.addEventListener("input", function () {
            const keyword = roomSearchInput.value.trim().toLowerCase();
            const items = roomSelectionList.querySelectorAll(".room-selection-item");

            items.forEach(function (item) {
                const code = (item.dataset.code || "").toLowerCase();
                const name = (item.dataset.name || "").toLowerCase();
                const isMatch = code.includes(keyword) || name.includes(keyword);
                item.style.display = isMatch ? "flex" : "none";
            });
        });
    }

    // =============================================
    // 3. NÚT "+ THÊM PHÒNG MỚI" (RESET FORM)
    // =============================================
    if (addAnotherRoomBtn) {
        addAnotherRoomBtn.addEventListener("click", function () {
            if (roomSelectionList) {
                roomSelectionList.querySelectorAll(".room-selection-item").forEach(function (el) {
                    el.classList.remove("selected");
                });
            }

            if (roomIdInput) roomIdInput.value = "0";
            if (roomCodeInput) roomCodeInput.value = "";
            if (roomPriceInput) roomPriceInput.value = "";
            if (roomFloorInput) roomFloorInput.value = "";
            if (roomStatusInput) roomStatusInput.value = "available";
            if (maxTenantsInput) maxTenantsInput.value = "2";
            if (descriptionInput) descriptionInput.value = "";
            if (descriptionCount) descriptionCount.textContent = "0";

            if (editingBadge) {
                editingBadge.textContent = "Chưa chọn phòng";
            }

            if (deleteRoomBtn) {
                deleteRoomBtn.disabled = true;
            }

            if (roomCodeInput) roomCodeInput.focus();
        });
    }

    // =============================================
    // 4. NÚT "LƯU" PHÒNG (GỌI API BACKEND)
    // =============================================
    if (saveButton) {
        saveButton.addEventListener("click", async function () {
            const idVal = Number(roomIdInput?.value || 0);
            const codeVal = roomCodeInput ? roomCodeInput.value.trim() : "";
            const priceVal = Number(roomPriceInput ? roomPriceInput.value : 0);
            const statusVal = roomStatusInput ? roomStatusInput.value : "available";
            const maxTenantsVal = Number(maxTenantsInput ? maxTenantsInput.value : 2);
            const floorVal = roomFloorInput ? roomFloorInput.value : "";

            if (!codeVal) {
                alert("Vui lòng nhập mã phòng.");
                roomCodeInput?.focus();
                return;
            }

            if (!floorVal) {
                alert("Vui lòng chọn tầng cho phòng.");
                roomFloorInput?.focus();
                return;
            }

            if (!priceVal || priceVal <= 0) {
                alert("Vui lòng nhập giá thuê hợp lệ.");
                roomPriceInput?.focus();
                return;
            }

            const payload = {
                id: idVal > 0 ? idVal : null,
                roomCode: codeVal,
                roomName: "Phòng " + codeVal,
                price: priceVal,
                maxTenants: maxTenantsVal > 0 ? maxTenantsVal : 2,
                status: statusVal
            };

            saveButton.disabled = true;
            saveButton.textContent = "Đang lưu...";

            try {
                const response = await fetch("/Landlord/SaveRoom", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(payload)
                });

                const result = await response.json();
                if (result.success) {
                    alert("✅ " + result.message);
                    window.location.href = "/Landlord/Rooms";
                } else {
                    alert("❌ " + result.message);
                    saveButton.disabled = false;
                    saveButton.textContent = "Lưu";
                }
            } catch (err) {
                console.error(err);
                alert("❌ Đã xảy ra lỗi khi kết nối máy chủ.");
                saveButton.disabled = false;
                saveButton.textContent = "Lưu";
            }
        });
    }

    // =============================================
    // 5. NÚT "XÓA PHÒNG" (GỌI API BACKEND)
    // =============================================
    if (deleteRoomBtn) {
        deleteRoomBtn.addEventListener("click", async function () {
            const idVal = Number(roomIdInput?.value || 0);
            const codeVal = roomCodeInput ? roomCodeInput.value.trim() : "";

            if (!idVal || idVal <= 0) {
                alert("Vui lòng chọn phòng cần xóa từ danh sách bên phải.");
                return;
            }

            const confirmed = confirm(
                `Bạn có chắc chắn muốn xóa phòng ${codeVal} không?\n` +
                `Lưu ý: Không thể xóa phòng đang có hợp đồng hiệu lực.`
            );

            if (!confirmed) return;

            deleteRoomBtn.disabled = true;
            deleteRoomBtn.textContent = "Đang xóa...";

            try {
                const response = await fetch("/Landlord/DeleteRoom?id=" + idVal, {
                    method: "POST"
                });

                const result = await response.json();
                if (result.success) {
                    alert("✅ " + result.message);
                    window.location.href = "/Landlord/Rooms";
                } else {
                    alert("❌ " + result.message);
                    deleteRoomBtn.disabled = false;
                    deleteRoomBtn.textContent = "Xóa phòng";
                }
            } catch (err) {
                console.error(err);
                alert("❌ Đã xảy ra lỗi khi kết nối máy chủ.");
                deleteRoomBtn.disabled = false;
                deleteRoomBtn.textContent = "Xóa phòng";
            }
        });
    }

    // Đếm ký tự mô tả
    if (descriptionInput && descriptionCount) {
        descriptionInput.addEventListener("input", function () {
            descriptionCount.textContent = descriptionInput.value.length;
        });
    }

    // Chọn ảnh
    if (imageInput) {
        imageInput.addEventListener("change", function () {
            const newImages = Array.from(imageInput.files);

            newImages.forEach(function (file) {
                if (selectedImages.length >= 5) {
                    return;
                }

                if (!file.type.startsWith("image/")) {
                    return;
                }

                selectedImages.push(file);
            });

            renderImages();
            imageInput.value = "";
        });
    }

    // Hiển thị ảnh đã chọn
    function renderImages() {
        if (!imageList) return;
        imageList.innerHTML = "";

        selectedImages.forEach(function (file, index) {
            const imageUrl = URL.createObjectURL(file);

            const preview = document.createElement("div");
            preview.className = "image-preview";

            const image = document.createElement("img");
            image.src = imageUrl;
            image.alt = "Ảnh phòng";

            const removeButton = document.createElement("button");
            removeButton.type = "button";
            removeButton.className = "remove-image-button";
            removeButton.textContent = "×";

            removeButton.addEventListener("click", function () {
                URL.revokeObjectURL(image.src);
                selectedImages.splice(index, 1);
                renderImages();
            });

            preview.appendChild(image);
            preview.appendChild(removeButton);
            imageList.appendChild(preview);
        });

        if (selectedImages.length < 5) {
            const addLabel = document.createElement("label");
            addLabel.className = "add-image-button";
            addLabel.htmlFor = "roomImages";
            addLabel.innerHTML = "<span>+</span><small>Thêm ảnh<br>JPG, PNG</small>";

            imageList.appendChild(addLabel);
        }
    }
});
