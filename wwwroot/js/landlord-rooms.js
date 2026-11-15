
document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchRoom");
    const statusFilter = document.getElementById("statusFilter");
    const floorFilter = document.getElementById("floorFilter");
    const roomList = document.getElementById("roomList");

    function filterRooms() {
        const searchValue = searchInput.value.trim().toLowerCase();
        const selectedStatus = statusFilter.value;
        const selectedFloor = floorFilter.value;

        const roomCards = roomList.querySelectorAll(".room-card");

        roomCards.forEach(function (card) {
            const roomName = card.dataset.name?.toLowerCase() || "";
            const roomStatus = card.dataset.status || "";
            const roomFloor = card.dataset.floor || "";

            const matchesName = roomName.includes(searchValue);
            const matchesStatus =
                selectedStatus === "" || roomStatus === selectedStatus;
            const matchesFloor =
                selectedFloor === "" || roomFloor === selectedFloor;

            card.style.display =
                matchesName && matchesStatus && matchesFloor
                    ? ""
                    : "none";
        });
    }

    searchInput.addEventListener("input", filterRooms);
    statusFilter.addEventListener("change", filterRooms);
    floorFilter.addEventListener("change", filterRooms);

    // =============================================
    // CHẤM DỨT HỢP ĐỒNG / TRẢ PHÒNG
    // =============================================
    if (roomList) {
        roomList.addEventListener("click", async function (e) {
            const btn = e.target.closest(".btn-terminate");
            if (!btn) return;

            const contractId = btn.dataset.contractId;
            const roomId = btn.dataset.roomId;
            const roomCode = btn.dataset.roomCode;
            const tenantName = btn.dataset.tenantName;

            const confirmed = confirm(
                `Bạn có chắc chắn muốn chấm dứt hợp đồng và trả phòng ${roomCode} (${tenantName}) không?\n` +
                `Toàn bộ thông tin hợp đồng của khách cũ sẽ được dọn dẹp và phòng sẽ chuyển về trạng thái Trống.`
            );

            if (!confirmed) return;

            btn.disabled = true;
            btn.textContent = "Đang xử lý...";

            try {
                const response = await fetch("/Landlord/TerminateContract", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `contractId=${encodeURIComponent(contractId)}&roomId=${encodeURIComponent(roomId)}`
                });

                const result = await response.json();
                if (result.success) {
                    alert("✅ " + result.message);
                    window.location.reload();
                } else {
                    alert("❌ " + result.message);
                    btn.disabled = false;
                    btn.textContent = "Chấm dứt HĐ";
                }
            } catch (err) {
                console.error(err);
                alert("❌ Đã xảy ra lỗi khi kết nối máy chủ.");
                btn.disabled = false;
                btn.textContent = "Chấm dứt HĐ";
            }
        });
    }
});
