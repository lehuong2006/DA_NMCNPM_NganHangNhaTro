
document.addEventListener("DOMContentLoaded", function () {
    const descriptionInput = document.getElementById("roomDescription");
    const descriptionCount = document.getElementById("descriptionCount");

    const imageInput = document.getElementById("roomImages");
    const imageList = document.getElementById("imageList");

    let selectedImages = [];

    // Đếm ký tự mô tả
    descriptionInput.addEventListener("input", function () {
        descriptionCount.textContent = descriptionInput.value.length;
    });

    // Chọn ảnh
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

    // Hiển thị ảnh đã chọn
    function renderImages() {
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
