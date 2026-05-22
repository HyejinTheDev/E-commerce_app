import {
  Controller,
  Post,
  UseInterceptors,
  UploadedFile,
  UploadedFiles,
  UseGuards,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { existsSync, mkdirSync } from 'fs';

// Ensure uploads directory exists
const uploadsDir = join(process.cwd(), 'uploads');
if (!existsSync(uploadsDir)) {
  mkdirSync(uploadsDir, { recursive: true });
}

const storage = diskStorage({
  destination: uploadsDir,
  filename: (_req, file, cb) => {
    const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1e6)}${extname(file.originalname)}`;
    cb(null, uniqueName);
  },
});

const imageFilter = (_req: any, file: any, cb: any) => {
  if (!file.mimetype.match(/\/(jpg|jpeg|png|gif|webp)$/)) {
    return cb(new BadRequestException('Chỉ hỗ trợ file ảnh (jpg, png, gif, webp)'), false);
  }
  cb(null, true);
};

@ApiTags('Upload')
@Controller('upload')
export class UploadController {
  @Post('image')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('file', {
      storage,
      fileFilter: imageFilter,
      limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
    }),
  )
  uploadImage(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('Không có file nào được upload');
    }
    const baseUrl = process.env.BASE_URL || 'http://10.0.2.2:3000';
    return {
      url: `${baseUrl}/uploads/${file.filename}`,
      filename: file.filename,
      size: file.size,
    };
  }

  @Post('images')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FilesInterceptor('files', 10, {
      storage,
      fileFilter: imageFilter,
      limits: { fileSize: 5 * 1024 * 1024 },
    }),
  )
  uploadImages(@UploadedFiles() files: Express.Multer.File[]) {
    if (!files || files.length === 0) {
      throw new BadRequestException('Không có file nào được upload');
    }
    const baseUrl = process.env.BASE_URL || 'http://10.0.2.2:3000';
    return files.map((file) => ({
      url: `${baseUrl}/uploads/${file.filename}`,
      filename: file.filename,
      size: file.size,
    }));
  }
}
