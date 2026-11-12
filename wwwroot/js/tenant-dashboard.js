document.addEventListener("DOMContentLoaded", function () {

    const invoiceTableBody = document.querySelector(
        ".tenant-table tbody"
    );

    const invoiceEmpty = document.querySelector(
        ".tenant-invoice-panel .tenant-empty"
    );

    if (invoiceTableBody && invoiceEmpty) {

        const hasInvoices = invoiceTableBody.children.length > 0;

        invoiceEmpty.hidden = hasInvoices;

    }

    const serviceList = document.querySelector(
        ".tenant-service-list"
    );

    const serviceEmpty = document.querySelector(
        ".service-empty"
    );

    if (serviceList && serviceEmpty) {

        const hasServices = serviceList.children.length > 0;

        serviceEmpty.hidden = hasServices;

    }

    const notificationContent = document.querySelector(
        ".tenant-notification-content"
    );

    const notificationEmpty = document.querySelector(
        ".notification-empty"
    );

    if (notificationContent && notificationEmpty) {

        const hasNotification =
            notificationContent.textContent.trim() !== "" ||
            notificationContent.children.length > 0;

        notificationEmpty.hidden = hasNotification;

    }

});
