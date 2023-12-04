import { Controller, Get } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('api/v1/users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService) {
  }

  @Get(':publicId/posts')
  async getUserPosts() {

  }

  @Get('my/posts')
  async getMyPosts() {

  }
}
