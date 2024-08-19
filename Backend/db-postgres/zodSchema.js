// schemas/schemas.js
const { z } = require("zod");

const stringToDate = z.string().transform((val) => new Date(val));
const dateToString = z.date().transform((date) => date.toISOString());

const addUserSchema = z.object({
  persId: z.string(),
  FirstName: z.string(),
  LastName: z.string(),
  Email: z.string().email(),
  Phone: z.string(), // Ensure Phone is included
  Password: z.string().min(6),
});

const subscriptionSchema = z.object({
  SubscriptionPlanID: z.number(), // Ensure this is a number
  StartDate: z.string(),
  EndDate: z.string(),
  Status: z.string().optional(), // Optional, as it may be added programmatically
});

const updateUserSchema = z.object({
  persId: z.number().int().optional(),
  FirstName: z.string().max(40).optional(),
  LastName: z.string().max(45).optional(),
  Phone: z.string().max(20).optional(),
  Email: z.string().email().max(100).optional(),
  Password: z.string().min(6).optional(),
});

const addCarSchema = z.object({
  RegistrationID: z.string().min(1).max(11),
  Model: z.string().min(1).max(45),
});
// HW_Alive Schema
const hwAliveSchema = z.object({
  Fault: z.boolean().default(false),
});

// Cars Schema
const carSchema = z.object({
  idCars: z.number().int().optional(),
  RegistrationID: z.string().length(11),
  Model: z.string().max(45),
  OwnerID: z.number().int().min(1),
});

// Areas Schema
const areaSchema = z.object({
  idAreas: z.number().int().optional(),
  AreaName: z.string().max(45),
});

// Gates Schema
const gateSchema = z.object({
  idGates: z.number().int().optional(),
  Entrance: z.boolean(),
  AreaID: z.number().int().min(1),
  Fault: z.boolean(),
});

// SlotSizes Schema
const slotSizeSchema = z.object({
  idSlotSizes: z.number().int().optional(),
  Size: z.string().max(45),
});

// Borders Schema
const borderSchema = z.object({
  idBorders: z.number().int().optional(),
  Violated: z.boolean(),
});

// Slots Schema
const slotSchema = z.object({
  idSlots: z.number().int().optional(),
  Busy: z.boolean(),
  Area: z.number().int().min(1),
  SavedFor: z.number().int().min(1),
  TakenBy: z.number().int().min(1),
  BorderLeft: z.number().int().min(1),
  BorderRigth: z.number().int().min(1),
  Size: z.number().int().min(1),
  Active: z.boolean(),
  Fault: z.boolean(),
});

// ParkingLog Schema
const parkingLogSchema = z.object({
  idParkingLog: z.number().int().optional(),
  CarID: z.number().int().min(1),
  SlotID: z.number().int().min(1),
  Entrance: z.string(), // Assuming timestamps are passed as strings (e.g., "2024-08-03T10:00:00Z")
  Exit: z.string(),
  ParkingStart: z.string(),
  ParkingEnd: z.string(),
  SavingStart: z.string(),
  SavingEnd: z.string(),
  Violation: z.boolean(),
});

module.exports = {
  hwAliveSchema,
  carSchema,
  areaSchema,
  gateSchema,
  slotSizeSchema,
  borderSchema,
  slotSchema,
  parkingLogSchema,
  addUserSchema,
  updateUserSchema,
  subscriptionSchema,
  addCarSchema,
};