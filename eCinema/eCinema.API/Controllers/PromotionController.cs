using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using eCinema.Services.Auth;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class PromotionController : BaseCRUDController<PromotionResponse, PromotionSearchObject, PromotionUpsertRequest, PromotionUpsertRequest>
    {
        private readonly ICurrentUserService _currentUserService;

        public PromotionController(IPromotionService service, ICurrentUserService currentUserService) : base(service)
        {
            _currentUserService = currentUserService;
        }

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<PromotionResponse> Create([FromBody] PromotionUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<PromotionResponse> Update(int id, [FromBody] PromotionUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }

        [HttpGet("validate/{code}")]
        public async Task<ActionResult<PromotionResponse>> ValidateCode(string code)
        {
            try 
            {
                var userId = await _currentUserService.GetUserIdAsync() ?? throw new Exception("User not found");
                var result = await (_service as IPromotionService).ValidatePromotionCode(code, userId);
                if (result == null)
                    return NotFound("Invalid or expired promotion code");
                    
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
} 