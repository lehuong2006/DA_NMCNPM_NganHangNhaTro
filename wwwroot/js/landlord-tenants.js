document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("tenantSearch");
    const roomFilter = document.getElementById("roomFilter");
    const statusFilter = document.getElementById("statusFilter");
    const filterButton = document.getElementById("filterButton");

    const tableBody = document.getElementById("tenantTableBody");
    const emptyMessage = document.querySelector(".tenant-empty");

    function filterTenants() {
        const searchValue = searchInput.value.trim().toLowerCase();
        const selectedRoom = roomFilter.value;
        const selectedStatus = statusFilter.value;

        const rows = tableBody.querySelectorAll("tr");
        let visibleCount = 0;

        rows.forEach(function (row) {
            const rowText = row.textContent.toLowerCase();
            const room = row.dataset.room || "";
            const status = row.dataset.status || "";

            const matchesSearch = rowText.includes(searchValue);
            const matchesRoom =
                selectedRoom === "" || room === selectedRoom;
            const matchesStatus =
                selectedStatus === "" || status === selectedStatus;

            const isVisible =
                matchesSearch && matchesRoom && matchesStatus;

            row.style.display = isVisible ? "" : "none";

            if (isVisible) {
                visibleCount++;
            }
        });

        emptyMessage.style.display =
            rows.length === 0 || visibleCount === 0 ? "flex" : "none";
    }

    searchInput.addEventListener("input", filterTenants);
    roomFilter.addEventListener("change", filterTenants);
    statusFilter.addEventListener("change", filterTenants);

    filterButton.addEventListener("click", filterTenants);

    // =============================================
    // CHẤM DỨT HỢP ĐỒNG CHO NGƯỜI THUÊ
    // =============================================
    if (tableBody) {
        tableBody.addEventListener("click", async function (e) {
            const btn = e.target.closest(".btn-terminate-tenant");
            if (!btn) return;

            const contractId = btn.dataset.contractId;
            const roomCode = btn.dataset.roomCode;
            const tenantName = btn.dataset.tenantName;

            const confirmed = confirm(
                `Bạn có chắc chắn muốn chấm dứt hợp đồng của ${tenantName} (Phòng ${roomCode}) không?\n` +
                `Toàn bộ thông tin hợp đồng của khách cũ sẽ được dọn dẹp và phòng sẽ chuyển về trạng thái Trống.`
            );

            if (!confirmed) return;

            btn.disabled = true;
            btn.textContent = "...";

            try {
                const response = await fetch("/Landlord/TerminateContract", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `contractId=${encodeURIComponent(contractId)}`
                });

                const result = await response.json();
                if (result.success) {
                    alert("✅ " + result.message);
                    window.location.reload();
                } else {
                    alert("❌ " + result.message);
                    btn.disabled = false;
                    btn.textContent = "Chấm dứt";
                }
            } catch (err) {
                console.error(err);
                alert("❌ Đã xảy ra lỗi khi kết nối máy chủ.");
                btn.disabled = false;
                btn.textContent = "Chấm dứt";
            }
        });
    }

    // Cập nhật trạng thái hiển thị ban đầu
    filterTenants();
});
