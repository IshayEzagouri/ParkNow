-- AlterTable
ALTER TABLE "ParkingLog" ALTER COLUMN "Exit" SET DATA TYPE TIMESTAMPTZ(6),
ALTER COLUMN "NeedToExitBy" SET DATA TYPE TIMESTAMPTZ(6);
