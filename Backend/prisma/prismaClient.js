// prismaClient.js
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function connectPrisma() {
  try {
    await prisma.$connect();
    console.log('Prisma Client connected successfully');
  } catch (error) {
    console.error('Error connecting Prisma Client:', error);
    process.exit(1);
  }
}

connectPrisma();

module.exports = prisma;
