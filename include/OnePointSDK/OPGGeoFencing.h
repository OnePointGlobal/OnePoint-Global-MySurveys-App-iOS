//
// Copyright (c) 2016 OnePoint Global Ltd. All rights reserved.
//
// This code is licensed under the OnePoint Global License.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "OPGBaseFencing.h"

@protocol OPGGeoFencingDelegate <NSObject>

/*!
 @brief This method indicates the survey available for the current location.
 
 @discussion This method indicates the list of survey available for user at current location/region.
 
 @return void.
 */
-(void)didEnterSurveyRegion:(NSArray*)locations;

/*!
 @brief This method indicates the unavailable surveys for the current location.
 
 @discussion This method indicates the list of survey that user has exited for the current region/location.
 
 @return void.
 */
-(void)didExitSurveyRegion:(NSArray*)locations;

@end

@interface OPGGeoFencing : OPGBaseFencing

@property(assign, nonatomic) id<OPGGeoFencingDelegate> geoFencingDelegate;


@end
