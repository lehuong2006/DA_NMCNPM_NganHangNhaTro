
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
});
