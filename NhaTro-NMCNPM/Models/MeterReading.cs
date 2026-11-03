using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NhaTro_NMCNPM.Models
{
    public class MeterReading
    {
        public int readingId { get; set; }
        public int roomId { get; set; }
        public int billingMonth { get; set; }
        public int billingYear { get; set; }
        public int oldElectricity { get; set; }
        public int newElectricity { get; set; }
        public int oldWater { get; set; }
        public int newWater { get; set; }
        public int tenantCount { get; set; }
        public int electricVehicleCount { get; set; }

        public decimal electricityUnitPrice { get; set; } = 3500;
        public decimal waterUnitPrice { get; set; } = 50000;
        public decimal internetUnitPrice { get; set; } = 50000;
        public decimal elevatorUnitPrice { get; set; } = 100000;
        public decimal washingUnitPrice { get; set; } = 50000;
        public decimal evChargingUnitPrice { get; set; } = 100000;

        public int electricityUsage => newElectricity - oldElectricity;
        public decimal totalElectricityFee => electricityUsage * electricityUnitPrice;
        public decimal totalWaterFee => tenantCount * waterUnitPrice;
        public decimal totalInternetFee => internetUnitPrice;
        public decimal totalElevatorFee => elevatorUnitPrice;
        public decimal totalWashingFee => washingUnitPrice;
        public decimal totalEvChargingFee => electricVehicleCount * evChargingUnitPrice;

        public decimal totalUtilityFee => totalElectricityFee + totalWaterFee + totalInternetFee + totalElevatorFee + totalWashingFee + totalEvChargingFee;
    }
}